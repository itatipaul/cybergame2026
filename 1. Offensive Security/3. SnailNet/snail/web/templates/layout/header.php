<?php
$flashSuccess = get_flash('success');
$flashError = get_flash('error');
?>
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>SnailNet 1998</title>
    <link rel="stylesheet" href="assets/style.css">
</head>
<body>
<div class="crt-overlay"></div>
<header class="top-banner">
    <marquee behavior="alternate" scrollamount="7">Welcome to SnailNet 1998 :: Under Construction, Likely Forever</marquee>
</header>

<nav class="main-nav">
    <a href="index.php">Home</a>
    <a href="index.php?action=search">Search</a>
    <?php if ($currentUser): ?>
        <span class="user-pill">Logged in: <?= h($currentUser['username']) ?></span>
        <?php if ((int) $currentUser['is_admin'] === 1): ?>
            <a href="index.php?action=admin-requests">Admin Desk</a>
        <?php endif; ?>
        <?php if ((int) $currentUser['can_post'] !== 1): ?>
            <a href="index.php?action=join-request">Join Request</a>
        <?php endif; ?>
        <a href="index.php?action=logout">Logout</a>
    <?php else: ?>
        <a href="index.php?action=login">Login</a>
        <a href="index.php?action=register">Register</a>
    <?php endif; ?>
</nav>

<main class="content-wrap">
    <?php if ($flashSuccess): ?>
        <div class="flash flash-success"><?= h($flashSuccess) ?></div>
    <?php endif; ?>

    <?php if ($flashError): ?>
        <div class="flash flash-error"><?= h($flashError) ?></div>
    <?php endif; ?>
