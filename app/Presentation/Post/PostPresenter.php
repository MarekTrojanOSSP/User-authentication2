<?php

namespace App\Presentation\Post;

use Nette;
use Nette\Application\UI\Form;
use App\Model\PostFacade;

final class PostPresenter extends Nette\Application\UI\Presenter
{
	public function __construct(
		private PostFacade $facade,
	) {}

	public function renderShow(int $postId): void
	{
		$post = $this->facade->getPostById($postId);
		if (!$post) {
			$this->error('Stránka nebyla nalezena');
		}

		$this->template->post = $post;
		$this->template->comments = $post->related('comment')->order('created_at');
		$this->facade->addViews($postId);
	}

	protected function createComponentCommentForm(): Form
	{
		$form = new Form; // means Nette\Application\UI\Form

		$form->addText('name', 'Jméno:')
			->setRequired();

		$form->addEmail('email', 'E-mail:');

		$form->addTextArea('content', 'Komentář:')
			->setRequired();

		$form->addSubmit('send', 'Publikovat komentář');

		$form->onSuccess[] = $this->commentFormSucceeded(...);

		return $form;
	}

	private function commentFormSucceeded(\stdClass $data): void
	{
		$postId = $this->getParameter('postId');

		$this->facade->getComment($postId)->insert([
			'post_id' => $postId,
			'name' => $data->name,
			'email' => $data->email,
			'content' => $data->content
		]);

		$this->flashMessage('Děkuji za komentář', 'success');
		$this->redirect('this');
	}

	public function handleDeleteComment(int $commentId, int $postId): void
	{
		$success = $this->facade->deleteComment($commentId);

		if ($success) {
			$this->flashMessage('Komentář byl úspěšně smazán!', 'success');
		} else {
			$this->flashMessage('Komentář se nezdařilo smazat!', 'error');
		}

		$this->redirect('this', ['postId' => $postId]);
	}

	public function addView(int $postId, int $view) {
		$this->template->views = $this->facade->addViews($postId, $view);
		
		 $this->table('post');
		 $this->count($view);
		 $this->update($view);
	}
	public function actionShow(int $postId): void 
{
    $post = $this->facade->getPostById($postId);

    if ($post->status === 'ARCHIVED' && !$this->user->isLoggedIn()) {
        $this->redirect('Home:default');
    }
}

}
