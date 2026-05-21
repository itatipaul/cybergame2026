<section class="panel">
    <h1>Admin Request Desk</h1>
    <p>Review member applications for posting and attachment access.</p>

    <?php if (!$requests): ?>
        <p>No requests yet.</p>
    <?php else: ?>
        <?php foreach ($requests as $req): ?>
            <article class="request-box">
                <h3>User: <?= h($req['username']) ?> | Status: <?= h($req['status']) ?></h3>
                <?php if (!empty($req['request_uuid'])): ?>
                    <p><strong>Public view:</strong> <a href="index.php?action=view-request&amp;id=<?= urlencode((string) $req['request_uuid']) ?>">index.php?action=view-request&amp;id=<?= h((string) $req['request_uuid']) ?></a></p>
                <?php endif; ?>
                <div class="post-content"><?= $req['content_html'] ?: nl2br(h(trim((string) $req['intro']) . "\n\n" . trim((string) $req['reason']))) ?></div>
                <?php if ($req['status'] === 'pending'): ?>
                    <form method="post" action="index.php?action=admin-requests" class="inline-form">
                        <input type="hidden" name="csrf_token" value="<?= h(csrf_token()) ?>">
                        <input type="hidden" name="request_id" value="<?= (int) $req['id'] ?>">
                        <label>Admin note</label>
                        <input type="text" name="note" placeholder="Optional moderation note">
                        <button class="button approve" name="decision" value="approve" type="submit">Approve</button>
                        <button class="button reject" name="decision" value="reject" type="submit">Reject</button>
                    </form>
                <?php else: ?>
                    <p><strong>Review note:</strong> <?= h((string) ($req['review_note'] ?? '')) ?></p>
                <?php endif; ?>
            </article>
        <?php endforeach; ?>
    <?php endif; ?>
</section>
