<section class="panel">
    <h1>Join Request</h1>
    <p><strong>User:</strong> <?= h($request['username']) ?></p>
    <p><strong>Status:</strong> <?= h($request['status']) ?></p>
    <p><strong>Request ID:</strong> <?= h((string) $request['request_uuid']) ?></p>
    <p><strong>Submitted:</strong> <?= h((string) $request['created_at']) ?></p>

    <div class="post-content"><?= $request['content_html'] ?: nl2br(h(trim((string) $request['intro']) . "\n\n" . trim((string) $request['reason']))) ?></div>

    <?php if (!empty($request['review_note'])): ?>
        <p><strong>Admin note:</strong> <?= h((string) $request['review_note']) ?></p>
    <?php endif; ?>

    <?php if (!empty($request['reviewed_at'])): ?>
        <p><strong>Reviewed at:</strong> <?= h((string) $request['reviewed_at']) ?></p>
    <?php endif; ?>
</section>
