<section class="panel">
    <h1><?= h($thread['title']) ?></h1>
    <p>Section: <a href="index.php?action=section&amp;slug=<?= urlencode($thread['section_slug']) ?>"><?= h($thread['section_name']) ?></a></p>
</section>

<section class="panel">
    <h2>Posts</h2>
    <?php foreach ($posts as $post): ?>
        <article class="post-box">
            <header>
                <strong><?= h($post['username']) ?></strong>
                <span class="post-date"><?= h($post['created_at']) ?></span>
            </header>
            <div class="post-content"><?= $post['content_html'] ?></div>
            <?php if (!empty($post['attachment_path'])): ?>
                <p>
                    <a class="button" href="index.php?action=download&amp;post_id=<?= (int) $post['id'] ?>">
                        Download attachment: <?= h((string) $post['attachment_original_name']) ?>
                    </a>
                </p>
            <?php endif; ?>
        </article>
    <?php endforeach; ?>
</section>

<?php if ($currentUser && (int) $currentUser['can_post'] === 1): ?>
<section class="panel">
    <h2>Reply</h2>
    <p>Markdown + OG emoji support: :) ;-) :D :P</p>
    <form method="post" action="index.php?action=reply" enctype="multipart/form-data">
        <input type="hidden" name="csrf_token" value="<?= h(csrf_token()) ?>">
        <input type="hidden" name="thread_id" value="<?= (int) $thread['id'] ?>">

        <label>Message</label>
        <textarea name="content_markdown" rows="7" required></textarea>

        <label>Attachment (optional, max 2MB)</label>
        <input type="file" name="attachment">

        <button class="button" type="submit">Post Reply</button>
    </form>
</section>
<?php else: ?>
<section class="panel tips">
    <h2>Posting Locked</h2>
    <p>Send your intro request to admin to unlock posting and attachment downloads.</p>
</section>
<?php endif; ?>
