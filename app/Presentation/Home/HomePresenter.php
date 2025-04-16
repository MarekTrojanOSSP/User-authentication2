<?php
namespace App\Presentation\Home;

use App\Model\PostFacade;
use Nette;

final class HomePresenter extends Nette\Application\UI\Presenter
{
	public function __construct(
		private PostFacade $facade,
	) {
	}

	public function renderDefault(int $page = 1): void
	{
		$this->template->categories = $this->facade->getCategories();
		
		$posts = $this->facade->getPublicArticles();

		$lastPage = 0;
		$this->template->posts = $posts->page($page, 5, $lastPage);

		$this->template->page = $page;
		$this->template->lastPage = $lastPage;
	}

	public function renderCategory(int $categoryId): void
	{	
		$this->template->categories = $this->facade->getCategories();
		$this->template->posts = $this->facade->getPostsByCategoryId($categoryId);
	}
	

}