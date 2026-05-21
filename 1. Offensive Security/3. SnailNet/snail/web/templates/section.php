<section class="panel">
    <h1><?= h($section['name']) ?></h1>
    <p><?= h($section['description']) ?></p>
</section>

<section class="panel">
    <h2>Threads</h2>
    <?php if (!$threads): ?>
        <p>No threads yet. Be the first approved snailposter.</p>
    <?php else: ?>
        <table class="retro-table">
            <thead>
                <tr>
                    <th>Title</th>
                    <th>Author</th>
                    <th>Posts</th>
                    <th>Last Activity</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($threads as $thread): ?>
                    <tr>
                        <td><a href="index.php?action=thread&amp;id=<?= (int) $thread['id'] ?>"><?= h($thread['title']) ?></a></td>
                        <td><?= h($thread['username']) ?></td>
                        <td><?= (int) $thread['post_count'] ?></td>
                        <td><?= h((string) ($thread['last_post_at'] ?? $thread['created_at'])) ?></td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    <?php endif; ?>
</section>

<?php if ($currentUser && (int) $currentUser['can_post'] === 1): ?>
<section class="panel">
    <h2>New Thread</h2>
    <p>Markdown enabled. Try snail pics with ![alt](https://example.com/snail.jpg) :)</p>
    <form method="post" action="index.php?action=new-thread">
        <input type="hidden" name="csrf_token" value="<?= h(csrf_token()) ?>">
        <input type="hidden" name="section_id" value="<?= (int) $section['id'] ?>">

        <label>Thread title</label>
        <input type="text" name="title" required>

        <label>Opening post (Markdown)</label>
        <textarea name="content_markdown" rows="8" required></textarea>

        <button class="button" type="submit">Post Thread</button>
    </form>
</section>
<?php else: ?>
<section class="panel tips">
    <h2>Read-only Mode</h2>
    <p>New users must send an admin request before posting threads.</p>
</section>
<?php endif; ?>
