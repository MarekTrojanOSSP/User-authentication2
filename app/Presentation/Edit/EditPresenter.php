<?php

namespace App\Presentation\Edit;

use Nette;
use App\Model\PostFacade;
use Nette\Application\UI\Form;

final class EditPresenter extends Nette\Application\UI\Presenter
{
	public function __construct(
		private PostFacade $facade,
	) {}

	protected function createComponentPostForm(): Form
	{
		$form = new Form;
		$form->addText('title', 'Titulek:')
			->setRequired();
		$form->addTextArea('content', 'Obsah:')
			->setRequired();
		$form->addUpload('image', 'Soubor')
			->setRequired()
			->addRule(Form::Image, 'Thumbnail must be JPEG, PNG or GIF');
		$form->addSelect('category_id', 'Kategorye:', $this->facade->getCategories()->fetchPairs('id', 'name'))
			->setRequired();
		$statuses = [
				'OPEN' => 'OTEVŘENÝ',
				'CLOSED' => 'UZAVŘENÝ',
				'ARCHIVED' => 'ARCHIVOVANÝ'
			];
			$form->addSelect('status', 'Stav:', $statuses)
				->setDefaultValue('OPEN');

		$form->addSubmit('send', 'Uložit a publikovat');
		$form->onSuccess[] = $this->postFormSucceeded(...);

		return $form;
	}

	private function postFormSucceeded(array $data): void
	{
		$postId = $this->getParameter('postId');

		if (filesize($data['image']) > 0) {
			$image = $data['image'];
			if ($image->isOK()) {
				$image->move('upload/' . $image->getSanitizedName());
				$image = 'upload/' . $image->getSanitizedName();
			}
		} else {
			$this->flashMessage('Soubor nebyl přidán', 'failed');
		}

		if ($postId) {
			$post = $this->facade->editPost($postId, $data);
			$this->flashMessage('Příspěvek byl úspěšně publikován.', 'success');
			$this->redirect('Post:show', $postId);
		} else {
			$this->facade->insertPost($data);
			$this->flashMessage('Příspěvek byl úspěšně publikován.', 'success');
		}
	}

	public function renderEdit(int $postId): void
	{
		$post = $this->facade->getPostById($postId);
		$this->template->post = $post;

		if (!$post) {
			$this->error('Post not found');
		}

		$this->getComponent('postForm')
			->setDefaults($post->toArray());
	}

	public function startup(): void
	{
		parent::startup();

		if (!$this->getUser()->isLoggedIn()) {
			$this->redirect('Sign:in');
		}
	}
	public function handleDeleteImage(int $postId)
	{
		$post = $this->facade->getPostById($postId);

		if ($post) {
			unlink($post['image']);

			$data['image'] = null;
			$this->facade->editPost($postId, $data);
			$this->flashMessage('Obrázek k příspěvku byl smazán');
		}

		if ($this->isAjax()) {
			$this->redrawControl('image');
			return;
		}
		$this->redirect('this');
	}
}
