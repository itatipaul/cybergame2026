.class public final Lf0/p;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Landroid/view/ViewTreeObserver$OnPreDrawListener;
.implements Landroid/view/View$OnAttachStateChangeListener;


# instance fields
.field public a:Lf0/m;

.field public b:Landroid/view/ViewGroup;


# virtual methods
.method public final onPreDraw()Z
    .locals 18

    move-object/from16 v0, p0

    iget-object v1, v0, Lf0/p;->b:Landroid/view/ViewGroup;

    invoke-virtual {v1}, Landroid/view/View;->getViewTreeObserver()Landroid/view/ViewTreeObserver;

    move-result-object v2

    invoke-virtual {v2, v0}, Landroid/view/ViewTreeObserver;->removeOnPreDrawListener(Landroid/view/ViewTreeObserver$OnPreDrawListener;)V

    invoke-virtual {v1, v0}, Landroid/view/View;->removeOnAttachStateChangeListener(Landroid/view/View$OnAttachStateChangeListener;)V

    sget-object v1, Lf0/q;->c:Ljava/util/ArrayList;

    iget-object v3, v0, Lf0/p;->b:Landroid/view/ViewGroup;

    invoke-virtual {v1, v3}, Ljava/util/ArrayList;->remove(Ljava/lang/Object;)Z

    move-result v1

    const/4 v8, 0x1

    if-nez v1, :cond_0

    return v8

    :cond_0
    invoke-static {}, Lf0/q;->b()Ln/b;

    move-result-object v1

    const/4 v2, 0x0

    invoke-virtual {v1, v3, v2}, Ln/k;->getOrDefault(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/util/ArrayList;

    if-nez v4, :cond_2

    new-instance v4, Ljava/util/ArrayList;

    invoke-direct {v4}, Ljava/util/ArrayList;-><init>()V

    invoke-virtual {v1, v3, v4}, Ln/k;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :cond_1
    move-object v5, v2

    goto :goto_0

    :cond_2
    invoke-virtual {v4}, Ljava/util/ArrayList;->size()I

    move-result v5

    if-lez v5, :cond_1

    new-instance v5, Ljava/util/ArrayList;

    invoke-direct {v5, v4}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    :goto_0
    iget-object v9, v0, Lf0/p;->a:Lf0/m;

    invoke-virtual {v4, v9}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    new-instance v4, Lf0/o;

    invoke-direct {v4, v0, v1}, Lf0/o;-><init>(Lf0/p;Ln/b;)V

    invoke-virtual {v9, v4}, Lf0/m;->a(Lf0/k;)V

    const/4 v1, 0x0

    invoke-virtual {v9, v3, v1}, Lf0/m;->h(Landroid/view/ViewGroup;Z)V

    if-eqz v5, :cond_3

    invoke-virtual {v5}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v4

    :goto_1
    invoke-interface {v4}, Ljava/util/Iterator;->hasNext()Z

    move-result v5

    if-eqz v5, :cond_3

    invoke-interface {v4}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Lf0/m;

    invoke-virtual {v5, v3}, Lf0/m;->y(Landroid/view/View;)V

    goto :goto_1

    :cond_3
    new-instance v4, Ljava/util/ArrayList;

    invoke-direct {v4}, Ljava/util/ArrayList;-><init>()V

    iput-object v4, v9, Lf0/m;->k:Ljava/util/ArrayList;

    new-instance v4, Ljava/util/ArrayList;

    invoke-direct {v4}, Ljava/util/ArrayList;-><init>()V

    iput-object v4, v9, Lf0/m;->l:Ljava/util/ArrayList;

    iget-object v4, v9, Lf0/m;->g:Landroidx/emoji2/text/v;

    iget-object v5, v9, Lf0/m;->h:Landroidx/emoji2/text/v;

    new-instance v6, Ln/b;

    iget-object v7, v4, Landroidx/emoji2/text/v;->a:Ljava/lang/Object;

    check-cast v7, Ln/b;

    invoke-direct {v6, v7}, Ln/b;-><init>(Ln/k;)V

    new-instance v7, Ln/b;

    iget-object v10, v5, Landroidx/emoji2/text/v;->a:Ljava/lang/Object;

    check-cast v10, Ln/b;

    invoke-direct {v7, v10}, Ln/b;-><init>(Ln/k;)V

    move v10, v1

    :goto_2
    iget-object v11, v9, Lf0/m;->j:[I

    array-length v12, v11

    if-ge v10, v12, :cond_e

    aget v11, v11, v10

    if-eq v11, v8, :cond_b

    const/4 v12, 0x2

    if-eq v11, v12, :cond_9

    const/4 v12, 0x3

    if-eq v11, v12, :cond_7

    const/4 v12, 0x4

    if-eq v11, v12, :cond_4

    goto/16 :goto_7

    :cond_4
    iget-object v11, v4, Landroidx/emoji2/text/v;->c:Ljava/lang/Object;

    check-cast v11, Ln/e;

    invoke-virtual {v11}, Ln/e;->f()I

    move-result v12

    move v13, v1

    :goto_3
    if-ge v13, v12, :cond_d

    invoke-virtual {v11, v13}, Ln/e;->g(I)Ljava/lang/Object;

    move-result-object v14

    check-cast v14, Landroid/view/View;

    if-eqz v14, :cond_6

    invoke-virtual {v9, v14}, Lf0/m;->t(Landroid/view/View;)Z

    move-result v15

    if-eqz v15, :cond_6

    iget-boolean v15, v11, Ln/e;->a:Z

    if-eqz v15, :cond_5

    invoke-virtual {v11}, Ln/e;->c()V

    :cond_5
    iget-object v15, v11, Ln/e;->b:[J

    move-object/from16 v16, v9

    aget-wide v8, v15, v13

    iget-object v15, v5, Landroidx/emoji2/text/v;->c:Ljava/lang/Object;

    check-cast v15, Ln/e;

    invoke-virtual {v15, v8, v9, v2}, Ln/e;->d(JLjava/lang/Long;)Ljava/lang/Object;

    move-result-object v8

    check-cast v8, Landroid/view/View;

    move-object/from16 v9, v16

    if-eqz v8, :cond_6

    invoke-virtual {v9, v8}, Lf0/m;->t(Landroid/view/View;)Z

    move-result v15

    if-eqz v15, :cond_6

    invoke-virtual {v6, v14, v2}, Ln/k;->getOrDefault(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v15

    check-cast v15, Lf0/u;

    invoke-virtual {v7, v8, v2}, Ln/k;->getOrDefault(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v16

    move-object/from16 v1, v16

    check-cast v1, Lf0/u;

    if-eqz v15, :cond_6

    if-eqz v1, :cond_6

    iget-object v2, v9, Lf0/m;->k:Ljava/util/ArrayList;

    invoke-virtual {v2, v15}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    iget-object v2, v9, Lf0/m;->l:Ljava/util/ArrayList;

    invoke-virtual {v2, v1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    invoke-virtual {v6, v14}, Ln/k;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    invoke-virtual {v7, v8}, Ln/k;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    :cond_6
    add-int/lit8 v13, v13, 0x1

    const/4 v1, 0x0

    const/4 v2, 0x0

    const/4 v8, 0x1

    goto :goto_3

    :cond_7
    iget-object v1, v4, Landroidx/emoji2/text/v;->b:Ljava/lang/Object;

    check-cast v1, Landroid/util/SparseArray;

    iget-object v2, v5, Landroidx/emoji2/text/v;->b:Ljava/lang/Object;

    check-cast v2, Landroid/util/SparseArray;

    invoke-virtual {v1}, Landroid/util/SparseArray;->size()I

    move-result v8

    const/4 v11, 0x0

    :goto_4
    if-ge v11, v8, :cond_d

    invoke-virtual {v1, v11}, Landroid/util/SparseArray;->valueAt(I)Ljava/lang/Object;

    move-result-object v12

    check-cast v12, Landroid/view/View;

    if-eqz v12, :cond_8

    invoke-virtual {v9, v12}, Lf0/m;->t(Landroid/view/View;)Z

    move-result v13

    if-eqz v13, :cond_8

    invoke-virtual {v1, v11}, Landroid/util/SparseArray;->keyAt(I)I

    move-result v13

    invoke-virtual {v2, v13}, Landroid/util/SparseArray;->get(I)Ljava/lang/Object;

    move-result-object v13

    check-cast v13, Landroid/view/View;

    if-eqz v13, :cond_8

    invoke-virtual {v9, v13}, Lf0/m;->t(Landroid/view/View;)Z

    move-result v14

    if-eqz v14, :cond_8

    const/4 v14, 0x0

    invoke-virtual {v6, v12, v14}, Ln/k;->getOrDefault(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v15

    check-cast v15, Lf0/u;

    invoke-virtual {v7, v13, v14}, Ln/k;->getOrDefault(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v17

    move-object/from16 v14, v17

    check-cast v14, Lf0/u;

    if-eqz v15, :cond_8

    if-eqz v14, :cond_8

    iget-object v0, v9, Lf0/m;->k:Ljava/util/ArrayList;

    invoke-virtual {v0, v15}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    iget-object v0, v9, Lf0/m;->l:Ljava/util/ArrayList;

    invoke-virtual {v0, v14}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    invoke-virtual {v6, v12}, Ln/k;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    invoke-virtual {v7, v13}, Ln/k;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    :cond_8
    add-int/lit8 v11, v11, 0x1

    move-object/from16 v0, p0

    goto :goto_4

    :cond_9
    iget-object v0, v4, Landroidx/emoji2/text/v;->d:Ljava/lang/Object;

    check-cast v0, Ln/b;

    iget v1, v0, Ln/k;->c:I

    const/4 v2, 0x0

    :goto_5
    if-ge v2, v1, :cond_d

    invoke-virtual {v0, v2}, Ln/k;->j(I)Ljava/lang/Object;

    move-result-object v8

    check-cast v8, Landroid/view/View;

    if-eqz v8, :cond_a

    invoke-virtual {v9, v8}, Lf0/m;->t(Landroid/view/View;)Z

    move-result v11

    if-eqz v11, :cond_a

    invoke-virtual {v0, v2}, Ln/k;->h(I)Ljava/lang/Object;

    move-result-object v11

    iget-object v12, v5, Landroidx/emoji2/text/v;->d:Ljava/lang/Object;

    check-cast v12, Ln/b;

    const/4 v13, 0x0

    invoke-virtual {v12, v11, v13}, Ln/k;->getOrDefault(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v11

    check-cast v11, Landroid/view/View;

    if-eqz v11, :cond_a

    invoke-virtual {v9, v11}, Lf0/m;->t(Landroid/view/View;)Z

    move-result v12

    if-eqz v12, :cond_a

    invoke-virtual {v6, v8, v13}, Ln/k;->getOrDefault(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v12

    check-cast v12, Lf0/u;

    invoke-virtual {v7, v11, v13}, Ln/k;->getOrDefault(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v14

    check-cast v14, Lf0/u;

    if-eqz v12, :cond_a

    if-eqz v14, :cond_a

    iget-object v13, v9, Lf0/m;->k:Ljava/util/ArrayList;

    invoke-virtual {v13, v12}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    iget-object v12, v9, Lf0/m;->l:Ljava/util/ArrayList;

    invoke-virtual {v12, v14}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    invoke-virtual {v6, v8}, Ln/k;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    invoke-virtual {v7, v11}, Ln/k;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    :cond_a
    add-int/lit8 v2, v2, 0x1

    goto :goto_5

    :cond_b
    iget v0, v6, Ln/k;->c:I

    const/4 v1, 0x1

    sub-int/2addr v0, v1

    :goto_6
    if-ltz v0, :cond_d

    invoke-virtual {v6, v0}, Ln/k;->h(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/view/View;

    if-eqz v1, :cond_c

    invoke-virtual {v9, v1}, Lf0/m;->t(Landroid/view/View;)Z

    move-result v2

    if-eqz v2, :cond_c

    invoke-virtual {v7, v1}, Ln/k;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lf0/u;

    if-eqz v1, :cond_c

    iget-object v2, v1, Lf0/u;->b:Landroid/view/View;

    invoke-virtual {v9, v2}, Lf0/m;->t(Landroid/view/View;)Z

    move-result v2

    if-eqz v2, :cond_c

    invoke-virtual {v6, v0}, Ln/k;->i(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lf0/u;

    iget-object v8, v9, Lf0/m;->k:Ljava/util/ArrayList;

    invoke-virtual {v8, v2}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    iget-object v2, v9, Lf0/m;->l:Ljava/util/ArrayList;

    invoke-virtual {v2, v1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    :cond_c
    add-int/lit8 v0, v0, -0x1

    goto :goto_6

    :cond_d
    :goto_7
    add-int/lit8 v10, v10, 0x1

    move-object/from16 v0, p0

    const/4 v1, 0x0

    const/4 v2, 0x0

    const/4 v8, 0x1

    goto/16 :goto_2

    :cond_e
    const/4 v0, 0x0

    :goto_8
    iget v1, v6, Ln/k;->c:I

    if-ge v0, v1, :cond_10

    invoke-virtual {v6, v0}, Ln/k;->j(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lf0/u;

    iget-object v2, v1, Lf0/u;->b:Landroid/view/View;

    invoke-virtual {v9, v2}, Lf0/m;->t(Landroid/view/View;)Z

    move-result v2

    if-eqz v2, :cond_f

    iget-object v2, v9, Lf0/m;->k:Ljava/util/ArrayList;

    invoke-virtual {v2, v1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    iget-object v1, v9, Lf0/m;->l:Ljava/util/ArrayList;

    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    :cond_f
    add-int/lit8 v0, v0, 0x1

    goto :goto_8

    :cond_10
    const/4 v1, 0x0

    :goto_9
    iget v0, v7, Ln/k;->c:I

    if-ge v1, v0, :cond_12

    invoke-virtual {v7, v1}, Ln/k;->j(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lf0/u;

    iget-object v2, v0, Lf0/u;->b:Landroid/view/View;

    invoke-virtual {v9, v2}, Lf0/m;->t(Landroid/view/View;)Z

    move-result v2

    if-eqz v2, :cond_11

    iget-object v2, v9, Lf0/m;->l:Ljava/util/ArrayList;

    invoke-virtual {v2, v0}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    iget-object v0, v9, Lf0/m;->k:Ljava/util/ArrayList;

    const/4 v2, 0x0

    invoke-virtual {v0, v2}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    :cond_11
    add-int/lit8 v1, v1, 0x1

    goto :goto_9

    :cond_12
    invoke-static {}, Lf0/m;->p()Ln/b;

    move-result-object v0

    iget v1, v0, Ln/k;->c:I

    invoke-virtual {v3}, Landroid/view/View;->getWindowId()Landroid/view/WindowId;

    move-result-object v2

    const/4 v4, 0x1

    sub-int/2addr v1, v4

    :goto_a
    if-ltz v1, :cond_19

    invoke-virtual {v0, v1}, Ln/k;->h(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/animation/Animator;

    if-eqz v4, :cond_17

    const/4 v5, 0x0

    invoke-virtual {v0, v4, v5}, Ln/k;->getOrDefault(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Lf0/j;

    if-eqz v6, :cond_17

    iget-object v5, v6, Lf0/j;->a:Landroid/view/View;

    if-eqz v5, :cond_17

    iget-object v7, v6, Lf0/j;->d:Landroid/view/WindowId;

    invoke-virtual {v2, v7}, Landroid/view/WindowId;->equals(Ljava/lang/Object;)Z

    move-result v7

    if-eqz v7, :cond_17

    const/4 v7, 0x1

    invoke-virtual {v9, v5, v7}, Lf0/m;->r(Landroid/view/View;Z)Lf0/u;

    move-result-object v8

    invoke-virtual {v9, v5, v7}, Lf0/m;->n(Landroid/view/View;Z)Lf0/u;

    move-result-object v10

    if-nez v8, :cond_13

    if-nez v10, :cond_13

    iget-object v7, v9, Lf0/m;->h:Landroidx/emoji2/text/v;

    iget-object v7, v7, Landroidx/emoji2/text/v;->a:Ljava/lang/Object;

    check-cast v7, Ln/b;

    const/4 v11, 0x0

    invoke-virtual {v7, v5, v11}, Ln/k;->getOrDefault(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v5

    move-object v10, v5

    check-cast v10, Lf0/u;

    goto :goto_b

    :cond_13
    const/4 v11, 0x0

    :goto_b
    if-nez v8, :cond_14

    if-eqz v10, :cond_18

    :cond_14
    iget-object v5, v6, Lf0/j;->c:Lf0/u;

    iget-object v6, v6, Lf0/j;->e:Lf0/m;

    invoke-virtual {v6, v5, v10}, Lf0/m;->s(Lf0/u;Lf0/u;)Z

    move-result v5

    if-eqz v5, :cond_18

    invoke-virtual {v6}, Lf0/m;->o()Lf0/m;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    invoke-virtual {v4}, Landroid/animation/Animator;->isRunning()Z

    move-result v5

    if-nez v5, :cond_16

    invoke-virtual {v4}, Landroid/animation/Animator;->isStarted()Z

    move-result v5

    if-eqz v5, :cond_15

    goto :goto_c

    :cond_15
    invoke-virtual {v0, v4}, Ln/k;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_d

    :cond_16
    :goto_c
    invoke-virtual {v4}, Landroid/animation/Animator;->cancel()V

    goto :goto_d

    :cond_17
    const/4 v11, 0x0

    :cond_18
    :goto_d
    add-int/lit8 v1, v1, -0x1

    goto :goto_a

    :cond_19
    iget-object v4, v9, Lf0/m;->g:Landroidx/emoji2/text/v;

    iget-object v5, v9, Lf0/m;->h:Landroidx/emoji2/text/v;

    iget-object v6, v9, Lf0/m;->k:Ljava/util/ArrayList;

    iget-object v7, v9, Lf0/m;->l:Ljava/util/ArrayList;

    move-object v2, v9

    invoke-virtual/range {v2 .. v7}, Lf0/m;->l(Landroid/view/ViewGroup;Landroidx/emoji2/text/v;Landroidx/emoji2/text/v;Ljava/util/ArrayList;Ljava/util/ArrayList;)V

    invoke-virtual {v9}, Lf0/m;->z()V

    const/4 v0, 0x1

    return v0
.end method

.method public final onViewAttachedToWindow(Landroid/view/View;)V
    .locals 0

    return-void
.end method

.method public final onViewDetachedFromWindow(Landroid/view/View;)V
    .locals 2

    iget-object p1, p0, Lf0/p;->b:Landroid/view/ViewGroup;

    invoke-virtual {p1}, Landroid/view/View;->getViewTreeObserver()Landroid/view/ViewTreeObserver;

    move-result-object v0

    invoke-virtual {v0, p0}, Landroid/view/ViewTreeObserver;->removeOnPreDrawListener(Landroid/view/ViewTreeObserver$OnPreDrawListener;)V

    invoke-virtual {p1, p0}, Landroid/view/View;->removeOnAttachStateChangeListener(Landroid/view/View$OnAttachStateChangeListener;)V

    sget-object p1, Lf0/q;->c:Ljava/util/ArrayList;

    iget-object v0, p0, Lf0/p;->b:Landroid/view/ViewGroup;

    invoke-virtual {p1, v0}, Ljava/util/ArrayList;->remove(Ljava/lang/Object;)Z

    invoke-static {}, Lf0/q;->b()Ln/b;

    move-result-object p1

    const/4 v1, 0x0

    invoke-virtual {p1, v0, v1}, Ln/k;->getOrDefault(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/util/ArrayList;

    if-eqz p1, :cond_0

    invoke-virtual {p1}, Ljava/util/ArrayList;->size()I

    move-result v1

    if-lez v1, :cond_0

    invoke-virtual {p1}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lf0/m;

    invoke-virtual {v1, v0}, Lf0/m;->y(Landroid/view/View;)V

    goto :goto_0

    :cond_0
    iget-object p1, p0, Lf0/p;->a:Lf0/m;

    const/4 v0, 0x1

    invoke-virtual {p1, v0}, Lf0/m;->i(Z)V

    return-void
.end method
