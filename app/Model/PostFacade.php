<?php

namespace App\Model;

use Nette;

final class PostFacade
{
	public function __construct(
		private Nette\Database\Explorer $database,
	) {}

	public function getPublicArticles()
	{
		return $this->database
			->table('post')
			->where('created_at < ', new \DateTime)
			->order('created_at DESC');
	}

	public function getPublishedArticlesCount(): int
	{
		return $this->database->fetchField('SELECT COUNT(*) FROM posts WHERE created_at < ?', new \DateTime);
	}

	public function getCategories()
	{
		return $this->database
			->table('category');
	}

	public function getPostById(int $postId)
	{
		return $this->database
			->table('post')
			->get($postId);
	}

	public function getPostsByCategoryId(int $categoryId)
	{
		return $this->database
			->table('post')
			->where('category_id', $categoryId)
			->fetchAll();
	}


	public function addComment(int $postId, \stdClass $data)
	{
		$this->database->table('comment')->insert([
			'post_id' => $postId,
			'name' => $data->name,
			'email' => $data->email,
			'content' => $data->content,
		]);
	}

	public function getComment(int $postId)
	{
		$post = $this->database->table("post")->get($postId);

		return $post->related("comment");
	}

	public function insertPost($data)
	{
		return $this->database
			->table('post')
			->insert((array)$data);
	}

	public function editPost(int $postId, $data)
	{
		$this->database
			->table('post')
			->where('id =', $postId)
			->update($data);
		return $postId;
	}

	public function deleteComment(int $commentId): void
	{
		$this->database
			->table('comment')
			->where('id', $commentId)
			->delete();
	}

	public function addViews($postId){
        $this->database->table('post')->wherePrimary($postId)->update([
            'view' => new \Nette\Database\SqlLiteral('view + 1')
        ]);
    }
}
