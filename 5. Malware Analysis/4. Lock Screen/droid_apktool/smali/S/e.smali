.class public final Ls/e;
.super Ljava/lang/Object;
.source "SourceFile"


# instance fields
.field public a:Lr/e;

.field public b:Z

.field public c:Z

.field public d:Lr/e;

.field public e:Ljava/util/ArrayList;

.field public f:Lu/f;

.field public g:Ls/b;

.field public h:Ljava/util/ArrayList;


# virtual methods
.method public final a(Ls/f;ILjava/util/ArrayList;Ls/l;)V
    .locals 6

    iget-object p1, p1, Ls/f;->d:Ls/o;

    iget-object v0, p1, Ls/o;->c:Ls/l;

    if-nez v0, :cond_a

    iget-object v0, p0, Ls/e;->a:Lr/e;

    iget-object v1, v0, Lr/d;->d:Ls/k;

    if-eq p1, v1, :cond_a

    iget-object v0, v0, Lr/d;->e:Ls/m;

    if-ne p1, v0, :cond_0

    goto/16 :goto_6

    :cond_0
    if-nez p4, :cond_1

    new-instance p4, Ls/l;

    invoke-direct {p4}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x0

    iput-object v0, p4, Ls/l;->a:Ls/o;

    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p4, Ls/l;->b:Ljava/util/ArrayList;

    iput-object p1, p4, Ls/l;->a:Ls/o;

    invoke-virtual {p3, p4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    :cond_1
    iput-object p4, p1, Ls/o;->c:Ls/l;

    iget-object v0, p4, Ls/l;->b:Ljava/util/ArrayList;

    invoke-virtual {v0, p1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    iget-object v0, p1, Ls/o;->h:Ls/f;

    iget-object v1, v0, Ls/f;->k:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :cond_2
    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_3

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ls/d;

    instance-of v3, v2, Ls/f;

    if-eqz v3, :cond_2

    check-cast v2, Ls/f;

    invoke-virtual {p0, v2, p2, p3, p4}, Ls/e;->a(Ls/f;ILjava/util/ArrayList;Ls/l;)V

    goto :goto_0

    :cond_3
    iget-object v1, p1, Ls/o;->i:Ls/f;

    iget-object v2, v1, Ls/f;->k:Ljava/util/ArrayList;

    invoke-virtual {v2}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :cond_4
    :goto_1
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_5

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ls/d;

    instance-of v4, v3, Ls/f;

    if-eqz v4, :cond_4

    check-cast v3, Ls/f;

    invoke-virtual {p0, v3, p2, p3, p4}, Ls/e;->a(Ls/f;ILjava/util/ArrayList;Ls/l;)V

    goto :goto_1

    :cond_5
    const/4 v2, 0x1

    if-ne p2, v2, :cond_7

    instance-of v3, p1, Ls/m;

    if-eqz v3, :cond_7

    move-object v3, p1

    check-cast v3, Ls/m;

    iget-object v3, v3, Ls/m;->k:Ls/f;

    iget-object v3, v3, Ls/f;->k:Ljava/util/ArrayList;

    invoke-virtual {v3}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :cond_6
    :goto_2
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_7

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ls/d;

    instance-of v5, v4, Ls/f;

    if-eqz v5, :cond_6

    check-cast v4, Ls/f;

    invoke-virtual {p0, v4, p2, p3, p4}, Ls/e;->a(Ls/f;ILjava/util/ArrayList;Ls/l;)V

    goto :goto_2

    :cond_7
    iget-object v0, v0, Ls/f;->l:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_3
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_8

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ls/f;

    invoke-virtual {p0, v3, p2, p3, p4}, Ls/e;->a(Ls/f;ILjava/util/ArrayList;Ls/l;)V

    goto :goto_3

    :cond_8
    iget-object v0, v1, Ls/f;->l:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_4
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_9

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ls/f;

    invoke-virtual {p0, v1, p2, p3, p4}, Ls/e;->a(Ls/f;ILjava/util/ArrayList;Ls/l;)V

    goto :goto_4

    :cond_9
    if-ne p2, v2, :cond_a

    instance-of v0, p1, Ls/m;

    if-eqz v0, :cond_a

    check-cast p1, Ls/m;

    iget-object p1, p1, Ls/m;->k:Ls/f;

    iget-object p1, p1, Ls/f;->l:Ljava/util/ArrayList;

    invoke-virtual {p1}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_5
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_a

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ls/f;

    invoke-virtual {p0, v0, p2, p3, p4}, Ls/e;->a(Ls/f;ILjava/util/ArrayList;Ls/l;)V

    goto :goto_5

    :cond_a
    :goto_6
    return-void
.end method

.method public final b(Lr/e;)V
    .locals 16

    move-object/from16 v0, p1

    iget-object v1, v0, Lr/e;->q0:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :cond_0
    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_28

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lr/d;

    iget-object v3, v2, Lr/d;->p0:[I

    const/4 v4, 0x0

    aget v5, v3, v4

    const/4 v9, 0x1

    aget v3, v3, v9

    iget v6, v2, Lr/d;->g0:I

    const/16 v7, 0x8

    if-ne v6, v7, :cond_1

    iput-boolean v9, v2, Lr/d;->a:Z

    goto :goto_0

    :cond_1
    iget v6, v2, Lr/d;->w:F

    const/high16 v10, 0x3f800000    # 1.0f

    cmpg-float v7, v6, v10

    const/4 v8, 0x3

    const/4 v11, 0x2

    if-gez v7, :cond_2

    if-ne v5, v8, :cond_2

    iput v11, v2, Lr/d;->r:I

    :cond_2
    iget v7, v2, Lr/d;->z:F

    cmpg-float v12, v7, v10

    if-gez v12, :cond_3

    if-ne v3, v8, :cond_3

    iput v11, v2, Lr/d;->s:I

    :cond_3
    iget v12, v2, Lr/d;->W:F

    const/4 v13, 0x0

    cmpl-float v12, v12, v13

    const/4 v13, 0x2

    const/4 v14, 0x1

    if-lez v12, :cond_9

    if-ne v5, v8, :cond_5

    if-eq v3, v13, :cond_4

    if-ne v3, v14, :cond_5

    :cond_4
    iput v8, v2, Lr/d;->r:I

    goto :goto_1

    :cond_5
    if-ne v3, v8, :cond_7

    if-eq v5, v13, :cond_6

    if-ne v5, v14, :cond_7

    :cond_6
    iput v8, v2, Lr/d;->s:I

    goto :goto_1

    :cond_7
    if-ne v5, v8, :cond_9

    if-ne v3, v8, :cond_9

    iget v12, v2, Lr/d;->r:I

    if-nez v12, :cond_8

    iput v8, v2, Lr/d;->r:I

    :cond_8
    iget v12, v2, Lr/d;->s:I

    if-nez v12, :cond_9

    iput v8, v2, Lr/d;->s:I

    :cond_9
    :goto_1
    iget-object v12, v2, Lr/d;->K:Lr/c;

    iget-object v15, v2, Lr/d;->I:Lr/c;

    if-ne v5, v8, :cond_b

    iget v10, v2, Lr/d;->r:I

    if-ne v10, v9, :cond_b

    iget-object v10, v15, Lr/c;->f:Lr/c;

    if-eqz v10, :cond_a

    iget-object v10, v12, Lr/c;->f:Lr/c;

    if-nez v10, :cond_b

    :cond_a
    move v5, v13

    :cond_b
    iget-object v10, v2, Lr/d;->L:Lr/c;

    iget-object v4, v2, Lr/d;->J:Lr/c;

    if-ne v3, v8, :cond_d

    iget v11, v2, Lr/d;->s:I

    if-ne v11, v9, :cond_d

    iget-object v11, v4, Lr/c;->f:Lr/c;

    if-eqz v11, :cond_c

    iget-object v11, v10, Lr/c;->f:Lr/c;

    if-nez v11, :cond_d

    :cond_c
    move v11, v13

    goto :goto_2

    :cond_d
    move v11, v3

    :goto_2
    iget-object v3, v2, Lr/d;->d:Ls/k;

    iput v5, v3, Ls/o;->d:I

    iget v9, v2, Lr/d;->r:I

    iput v9, v3, Ls/o;->a:I

    iget-object v3, v2, Lr/d;->e:Ls/m;

    iput v11, v3, Ls/o;->d:I

    iget v8, v2, Lr/d;->s:I

    iput v8, v3, Ls/o;->a:I

    const/4 v3, 0x4

    if-eq v5, v3, :cond_e

    if-eq v5, v14, :cond_e

    if-ne v5, v13, :cond_f

    :cond_e
    if-eq v11, v3, :cond_25

    if-eq v11, v14, :cond_25

    if-ne v11, v13, :cond_f

    goto/16 :goto_a

    :cond_f
    iget-object v4, v0, Lr/d;->p0:[I

    iget-object v10, v2, Lr/d;->Q:[Lr/c;

    const/high16 v12, 0x3f000000    # 0.5f

    const/4 v15, 0x3

    if-ne v5, v15, :cond_10

    if-eq v11, v13, :cond_11

    if-ne v11, v14, :cond_10

    goto :goto_3

    :cond_10
    move v3, v15

    goto/16 :goto_5

    :cond_11
    :goto_3
    if-ne v9, v15, :cond_13

    if-ne v11, v13, :cond_12

    const/4 v7, 0x0

    const/4 v5, 0x0

    move-object/from16 v3, p0

    move v4, v13

    move v6, v13

    move-object v8, v2

    invoke-virtual/range {v3 .. v8}, Ls/e;->f(IIIILr/d;)V

    :cond_12
    invoke-virtual {v2}, Lr/d;->k()I

    move-result v7

    int-to-float v3, v7

    iget v4, v2, Lr/d;->W:F

    mul-float/2addr v3, v4

    add-float/2addr v3, v12

    float-to-int v5, v3

    move-object/from16 v3, p0

    move v4, v14

    move v6, v14

    move-object v8, v2

    invoke-virtual/range {v3 .. v8}, Ls/e;->f(IIIILr/d;)V

    iget-object v3, v2, Lr/d;->d:Ls/k;

    iget-object v3, v3, Ls/o;->e:Ls/g;

    invoke-virtual {v2}, Lr/d;->q()I

    move-result v4

    invoke-virtual {v3, v4}, Ls/g;->d(I)V

    iget-object v3, v2, Lr/d;->e:Ls/m;

    iget-object v3, v3, Ls/o;->e:Ls/g;

    invoke-virtual {v2}, Lr/d;->k()I

    move-result v4

    invoke-virtual {v3, v4}, Ls/g;->d(I)V

    const/4 v15, 0x1

    iput-boolean v15, v2, Lr/d;->a:Z

    goto/16 :goto_0

    :cond_13
    const/4 v15, 0x1

    if-ne v9, v15, :cond_14

    const/4 v5, 0x0

    const/4 v7, 0x0

    move-object/from16 v3, p0

    move v4, v13

    move v6, v11

    move-object v8, v2

    invoke-virtual/range {v3 .. v8}, Ls/e;->f(IIIILr/d;)V

    iget-object v3, v2, Lr/d;->d:Ls/k;

    iget-object v3, v3, Ls/o;->e:Ls/g;

    invoke-virtual {v2}, Lr/d;->q()I

    move-result v2

    iput v2, v3, Ls/g;->m:I

    goto/16 :goto_0

    :cond_14
    const/4 v15, 0x2

    if-ne v9, v15, :cond_17

    const/4 v15, 0x0

    aget v13, v4, v15

    if-eq v13, v14, :cond_16

    if-ne v13, v3, :cond_15

    goto :goto_4

    :cond_15
    const/4 v3, 0x3

    goto :goto_5

    :cond_16
    :goto_4
    invoke-virtual/range {p1 .. p1}, Lr/d;->q()I

    move-result v3

    int-to-float v3, v3

    mul-float/2addr v6, v3

    add-float/2addr v6, v12

    float-to-int v5, v6

    invoke-virtual {v2}, Lr/d;->k()I

    move-result v7

    move-object/from16 v3, p0

    move v4, v14

    move v6, v11

    move-object v8, v2

    invoke-virtual/range {v3 .. v8}, Ls/e;->f(IIIILr/d;)V

    iget-object v3, v2, Lr/d;->d:Ls/k;

    iget-object v3, v3, Ls/o;->e:Ls/g;

    invoke-virtual {v2}, Lr/d;->q()I

    move-result v4

    invoke-virtual {v3, v4}, Ls/g;->d(I)V

    iget-object v3, v2, Lr/d;->e:Ls/m;

    iget-object v3, v3, Ls/o;->e:Ls/g;

    invoke-virtual {v2}, Lr/d;->k()I

    move-result v4

    invoke-virtual {v3, v4}, Ls/g;->d(I)V

    const/4 v13, 0x1

    iput-boolean v13, v2, Lr/d;->a:Z

    goto/16 :goto_0

    :cond_17
    const/4 v13, 0x1

    const/4 v15, 0x0

    aget-object v3, v10, v15

    iget-object v3, v3, Lr/c;->f:Lr/c;

    if-eqz v3, :cond_18

    aget-object v3, v10, v13

    iget-object v3, v3, Lr/c;->f:Lr/c;

    if-nez v3, :cond_15

    :cond_18
    const/4 v5, 0x0

    const/4 v7, 0x0

    move-object/from16 v3, p0

    const/4 v4, 0x2

    move v6, v11

    move-object v8, v2

    invoke-virtual/range {v3 .. v8}, Ls/e;->f(IIIILr/d;)V

    iget-object v3, v2, Lr/d;->d:Ls/k;

    iget-object v3, v3, Ls/o;->e:Ls/g;

    invoke-virtual {v2}, Lr/d;->q()I

    move-result v4

    invoke-virtual {v3, v4}, Ls/g;->d(I)V

    iget-object v3, v2, Lr/d;->e:Ls/m;

    iget-object v3, v3, Ls/o;->e:Ls/g;

    invoke-virtual {v2}, Lr/d;->k()I

    move-result v4

    invoke-virtual {v3, v4}, Ls/g;->d(I)V

    const/4 v3, 0x1

    iput-boolean v3, v2, Lr/d;->a:Z

    goto/16 :goto_0

    :goto_5
    if-ne v11, v3, :cond_1f

    const/4 v13, 0x2

    if-eq v5, v13, :cond_1a

    if-ne v5, v14, :cond_19

    goto :goto_6

    :cond_19
    move v10, v3

    const/4 v3, 0x1

    goto/16 :goto_8

    :cond_1a
    :goto_6
    if-ne v8, v3, :cond_1d

    if-ne v5, v13, :cond_1b

    const/4 v7, 0x0

    const/4 v5, 0x0

    move-object/from16 v3, p0

    move v4, v13

    move v6, v13

    move-object v8, v2

    invoke-virtual/range {v3 .. v8}, Ls/e;->f(IIIILr/d;)V

    :cond_1b
    invoke-virtual {v2}, Lr/d;->q()I

    move-result v5

    iget v3, v2, Lr/d;->W:F

    iget v4, v2, Lr/d;->X:I

    const/4 v6, -0x1

    if-ne v4, v6, :cond_1c

    const/high16 v4, 0x3f800000    # 1.0f

    div-float v3, v4, v3

    :cond_1c
    int-to-float v4, v5

    mul-float/2addr v4, v3

    add-float/2addr v4, v12

    float-to-int v7, v4

    move-object/from16 v3, p0

    move v4, v14

    move v6, v14

    move-object v8, v2

    invoke-virtual/range {v3 .. v8}, Ls/e;->f(IIIILr/d;)V

    iget-object v3, v2, Lr/d;->d:Ls/k;

    iget-object v3, v3, Ls/o;->e:Ls/g;

    invoke-virtual {v2}, Lr/d;->q()I

    move-result v4

    invoke-virtual {v3, v4}, Ls/g;->d(I)V

    iget-object v3, v2, Lr/d;->e:Ls/m;

    iget-object v3, v3, Ls/o;->e:Ls/g;

    invoke-virtual {v2}, Lr/d;->k()I

    move-result v4

    invoke-virtual {v3, v4}, Ls/g;->d(I)V

    const/4 v3, 0x1

    iput-boolean v3, v2, Lr/d;->a:Z

    goto/16 :goto_0

    :cond_1d
    const/4 v3, 0x1

    if-ne v8, v3, :cond_1e

    const/4 v7, 0x0

    const/4 v6, 0x0

    move-object/from16 v3, p0

    move v4, v5

    move v5, v6

    const/4 v6, 0x2

    move-object v8, v2

    invoke-virtual/range {v3 .. v8}, Ls/e;->f(IIIILr/d;)V

    iget-object v3, v2, Lr/d;->e:Ls/m;

    iget-object v3, v3, Ls/o;->e:Ls/g;

    invoke-virtual {v2}, Lr/d;->k()I

    move-result v2

    iput v2, v3, Ls/g;->m:I

    goto/16 :goto_0

    :cond_1e
    const/4 v3, 0x2

    if-ne v8, v3, :cond_21

    const/4 v3, 0x1

    aget v10, v4, v3

    if-eq v10, v14, :cond_20

    const/4 v3, 0x4

    if-ne v10, v3, :cond_1f

    goto :goto_7

    :cond_1f
    const/4 v3, 0x1

    const/4 v10, 0x3

    goto :goto_8

    :cond_20
    :goto_7
    invoke-virtual {v2}, Lr/d;->q()I

    move-result v6

    invoke-virtual/range {p1 .. p1}, Lr/d;->k()I

    move-result v3

    int-to-float v3, v3

    mul-float/2addr v7, v3

    add-float/2addr v7, v12

    float-to-int v7, v7

    move-object/from16 v3, p0

    move v4, v5

    move v5, v6

    move v6, v14

    move-object v8, v2

    invoke-virtual/range {v3 .. v8}, Ls/e;->f(IIIILr/d;)V

    iget-object v3, v2, Lr/d;->d:Ls/k;

    iget-object v3, v3, Ls/o;->e:Ls/g;

    invoke-virtual {v2}, Lr/d;->q()I

    move-result v4

    invoke-virtual {v3, v4}, Ls/g;->d(I)V

    iget-object v3, v2, Lr/d;->e:Ls/m;

    iget-object v3, v3, Ls/o;->e:Ls/g;

    invoke-virtual {v2}, Lr/d;->k()I

    move-result v4

    invoke-virtual {v3, v4}, Ls/g;->d(I)V

    const/4 v3, 0x1

    iput-boolean v3, v2, Lr/d;->a:Z

    goto/16 :goto_0

    :cond_21
    aget-object v13, v10, v3

    iget-object v3, v13, Lr/c;->f:Lr/c;

    if-eqz v3, :cond_22

    const/4 v3, 0x3

    aget-object v10, v10, v3

    iget-object v3, v10, Lr/c;->f:Lr/c;

    if-nez v3, :cond_1f

    :cond_22
    const/4 v5, 0x0

    const/4 v7, 0x0

    move-object/from16 v3, p0

    const/4 v4, 0x2

    move v6, v11

    move-object v8, v2

    invoke-virtual/range {v3 .. v8}, Ls/e;->f(IIIILr/d;)V

    iget-object v3, v2, Lr/d;->d:Ls/k;

    iget-object v3, v3, Ls/o;->e:Ls/g;

    invoke-virtual {v2}, Lr/d;->q()I

    move-result v4

    invoke-virtual {v3, v4}, Ls/g;->d(I)V

    iget-object v3, v2, Lr/d;->e:Ls/m;

    iget-object v3, v3, Ls/o;->e:Ls/g;

    invoke-virtual {v2}, Lr/d;->k()I

    move-result v4

    invoke-virtual {v3, v4}, Ls/g;->d(I)V

    const/4 v3, 0x1

    iput-boolean v3, v2, Lr/d;->a:Z

    goto/16 :goto_0

    :goto_8
    if-ne v5, v10, :cond_0

    if-ne v11, v10, :cond_0

    if-eq v9, v3, :cond_24

    if-ne v8, v3, :cond_23

    goto :goto_9

    :cond_23
    const/4 v5, 0x2

    if-ne v8, v5, :cond_0

    if-ne v9, v5, :cond_0

    const/4 v5, 0x0

    aget v5, v4, v5

    if-ne v5, v14, :cond_0

    aget v4, v4, v3

    if-ne v4, v14, :cond_0

    invoke-virtual/range {p1 .. p1}, Lr/d;->q()I

    move-result v3

    int-to-float v3, v3

    mul-float/2addr v6, v3

    add-float/2addr v6, v12

    float-to-int v5, v6

    invoke-virtual/range {p1 .. p1}, Lr/d;->k()I

    move-result v3

    int-to-float v3, v3

    mul-float/2addr v7, v3

    add-float/2addr v7, v12

    float-to-int v7, v7

    move-object/from16 v3, p0

    move v4, v14

    move v6, v14

    move-object v8, v2

    invoke-virtual/range {v3 .. v8}, Ls/e;->f(IIIILr/d;)V

    iget-object v3, v2, Lr/d;->d:Ls/k;

    iget-object v3, v3, Ls/o;->e:Ls/g;

    invoke-virtual {v2}, Lr/d;->q()I

    move-result v4

    invoke-virtual {v3, v4}, Ls/g;->d(I)V

    iget-object v3, v2, Lr/d;->e:Ls/m;

    iget-object v3, v3, Ls/o;->e:Ls/g;

    invoke-virtual {v2}, Lr/d;->k()I

    move-result v4

    invoke-virtual {v3, v4}, Ls/g;->d(I)V

    const/4 v3, 0x1

    iput-boolean v3, v2, Lr/d;->a:Z

    goto/16 :goto_0

    :cond_24
    :goto_9
    const/4 v7, 0x0

    const/4 v5, 0x0

    move-object/from16 v3, p0

    const/4 v6, 0x2

    move v4, v6

    move-object v8, v2

    invoke-virtual/range {v3 .. v8}, Ls/e;->f(IIIILr/d;)V

    iget-object v3, v2, Lr/d;->d:Ls/k;

    iget-object v3, v3, Ls/o;->e:Ls/g;

    invoke-virtual {v2}, Lr/d;->q()I

    move-result v4

    iput v4, v3, Ls/g;->m:I

    iget-object v3, v2, Lr/d;->e:Ls/m;

    iget-object v3, v3, Ls/o;->e:Ls/g;

    invoke-virtual {v2}, Lr/d;->k()I

    move-result v2

    iput v2, v3, Ls/g;->m:I

    goto/16 :goto_0

    :cond_25
    :goto_a
    invoke-virtual {v2}, Lr/d;->q()I

    move-result v3

    const/4 v6, 0x4

    if-ne v5, v6, :cond_26

    invoke-virtual/range {p1 .. p1}, Lr/d;->q()I

    move-result v3

    iget v5, v15, Lr/c;->g:I

    sub-int/2addr v3, v5

    iget v5, v12, Lr/c;->g:I

    sub-int/2addr v3, v5

    move v7, v3

    move v5, v14

    goto :goto_b

    :cond_26
    move v7, v3

    :goto_b
    invoke-virtual {v2}, Lr/d;->k()I

    move-result v3

    if-ne v11, v6, :cond_27

    invoke-virtual/range {p1 .. p1}, Lr/d;->k()I

    move-result v3

    iget v4, v4, Lr/c;->g:I

    sub-int/2addr v3, v4

    iget v4, v10, Lr/c;->g:I

    sub-int/2addr v3, v4

    move v8, v3

    move v6, v14

    goto :goto_c

    :cond_27
    move v8, v3

    move v6, v11

    :goto_c
    move-object/from16 v3, p0

    move v4, v5

    move v5, v7

    move v7, v8

    move-object v8, v2

    invoke-virtual/range {v3 .. v8}, Ls/e;->f(IIIILr/d;)V

    iget-object v3, v2, Lr/d;->d:Ls/k;

    iget-object v3, v3, Ls/o;->e:Ls/g;

    invoke-virtual {v2}, Lr/d;->q()I

    move-result v4

    invoke-virtual {v3, v4}, Ls/g;->d(I)V

    iget-object v3, v2, Lr/d;->e:Ls/m;

    iget-object v3, v3, Ls/o;->e:Ls/g;

    invoke-virtual {v2}, Lr/d;->k()I

    move-result v4

    invoke-virtual {v3, v4}, Ls/g;->d(I)V

    const/4 v3, 0x1

    iput-boolean v3, v2, Lr/d;->a:Z

    goto/16 :goto_0

    :cond_28
    return-void
.end method

.method public final c()V
    .locals 8

    iget-object v0, p0, Ls/e;->e:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->clear()V

    iget-object v1, p0, Ls/e;->d:Lr/e;

    iget-object v2, v1, Lr/d;->d:Ls/k;

    invoke-virtual {v2}, Ls/k;->f()V

    iget-object v2, v1, Lr/d;->e:Ls/m;

    invoke-virtual {v2}, Ls/m;->f()V

    iget-object v2, v1, Lr/d;->d:Ls/k;

    invoke-virtual {v0, v2}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    iget-object v2, v1, Lr/d;->e:Ls/m;

    invoke-virtual {v0, v2}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    iget-object v2, v1, Lr/e;->q0:Ljava/util/ArrayList;

    invoke-virtual {v2}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v2

    const/4 v3, 0x0

    :cond_0
    :goto_0
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    const/4 v5, 0x1

    const/4 v6, 0x0

    if-eqz v4, :cond_8

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lr/d;

    instance-of v7, v4, Lr/h;

    if-eqz v7, :cond_1

    new-instance v5, Ls/i;

    invoke-direct {v5, v4}, Ls/o;-><init>(Lr/d;)V

    iget-object v6, v4, Lr/d;->d:Ls/k;

    invoke-virtual {v6}, Ls/k;->f()V

    iget-object v6, v4, Lr/d;->e:Ls/m;

    invoke-virtual {v6}, Ls/m;->f()V

    check-cast v4, Lr/h;

    iget v4, v4, Lr/h;->u0:I

    iput v4, v5, Ls/o;->f:I

    invoke-virtual {v0, v5}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_0

    :cond_1
    invoke-virtual {v4}, Lr/d;->x()Z

    move-result v7

    if-eqz v7, :cond_4

    iget-object v7, v4, Lr/d;->b:Ls/c;

    if-nez v7, :cond_2

    new-instance v7, Ls/c;

    invoke-direct {v7, v4, v6}, Ls/c;-><init>(Lr/d;I)V

    iput-object v7, v4, Lr/d;->b:Ls/c;

    :cond_2
    if-nez v3, :cond_3

    new-instance v3, Ljava/util/HashSet;

    invoke-direct {v3}, Ljava/util/HashSet;-><init>()V

    :cond_3
    iget-object v6, v4, Lr/d;->b:Ls/c;

    invoke-virtual {v3, v6}, Ljava/util/HashSet;->add(Ljava/lang/Object;)Z

    goto :goto_1

    :cond_4
    iget-object v6, v4, Lr/d;->d:Ls/k;

    invoke-virtual {v0, v6}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    :goto_1
    invoke-virtual {v4}, Lr/d;->y()Z

    move-result v6

    if-eqz v6, :cond_7

    iget-object v6, v4, Lr/d;->c:Ls/c;

    if-nez v6, :cond_5

    new-instance v6, Ls/c;

    invoke-direct {v6, v4, v5}, Ls/c;-><init>(Lr/d;I)V

    iput-object v6, v4, Lr/d;->c:Ls/c;

    :cond_5
    if-nez v3, :cond_6

    new-instance v3, Ljava/util/HashSet;

    invoke-direct {v3}, Ljava/util/HashSet;-><init>()V

    :cond_6
    iget-object v5, v4, Lr/d;->c:Ls/c;

    invoke-virtual {v3, v5}, Ljava/util/HashSet;->add(Ljava/lang/Object;)Z

    goto :goto_2

    :cond_7
    iget-object v5, v4, Lr/d;->e:Ls/m;

    invoke-virtual {v0, v5}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    :goto_2
    instance-of v5, v4, Lr/i;

    if-eqz v5, :cond_0

    new-instance v5, Ls/j;

    invoke-direct {v5, v4}, Ls/o;-><init>(Lr/d;)V

    invoke-virtual {v0, v5}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_0

    :cond_8
    if-eqz v3, :cond_9

    invoke-virtual {v0, v3}, Ljava/util/ArrayList;->addAll(Ljava/util/Collection;)Z

    :cond_9
    invoke-virtual {v0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :goto_3
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_a

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ls/o;

    invoke-virtual {v3}, Ls/o;->f()V

    goto :goto_3

    :cond_a
    invoke-virtual {v0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_4
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_c

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ls/o;

    iget-object v3, v2, Ls/o;->b:Lr/d;

    if-ne v3, v1, :cond_b

    goto :goto_4

    :cond_b
    invoke-virtual {v2}, Ls/o;->d()V

    goto :goto_4

    :cond_c
    iget-object v0, p0, Ls/e;->h:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->clear()V

    iget-object v1, p0, Ls/e;->a:Lr/e;

    iget-object v2, v1, Lr/d;->d:Ls/k;

    invoke-virtual {p0, v2, v6, v0}, Ls/e;->e(Ls/o;ILjava/util/ArrayList;)V

    iget-object v1, v1, Lr/d;->e:Ls/m;

    invoke-virtual {p0, v1, v5, v0}, Ls/e;->e(Ls/o;ILjava/util/ArrayList;)V

    iput-boolean v6, p0, Ls/e;->b:Z

    return-void
.end method

.method public final d(Lr/e;I)I
    .locals 19

    move-object/from16 v0, p1

    move-object/from16 v1, p0

    move/from16 v2, p2

    iget-object v3, v1, Ls/e;->h:Ljava/util/ArrayList;

    invoke-virtual {v3}, Ljava/util/ArrayList;->size()I

    move-result v4

    const/4 v7, 0x0

    const-wide/16 v8, 0x0

    :goto_0
    if-ge v7, v4, :cond_d

    invoke-virtual {v3, v7}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v10

    check-cast v10, Ls/l;

    iget-object v10, v10, Ls/l;->a:Ls/o;

    instance-of v11, v10, Ls/c;

    if-eqz v11, :cond_0

    move-object v11, v10

    check-cast v11, Ls/c;

    iget v11, v11, Ls/o;->f:I

    if-eq v11, v2, :cond_2

    :goto_1
    move-object/from16 v18, v3

    move/from16 v16, v4

    move/from16 v17, v7

    const-wide/16 v0, 0x0

    goto/16 :goto_8

    :cond_0
    if-nez v2, :cond_1

    instance-of v11, v10, Ls/k;

    if-nez v11, :cond_2

    goto :goto_1

    :cond_1
    instance-of v11, v10, Ls/m;

    if-nez v11, :cond_2

    goto :goto_1

    :cond_2
    if-nez v2, :cond_3

    iget-object v11, v0, Lr/d;->d:Ls/k;

    :goto_2
    iget-object v11, v11, Ls/o;->h:Ls/f;

    goto :goto_3

    :cond_3
    iget-object v11, v0, Lr/d;->e:Ls/m;

    goto :goto_2

    :goto_3
    if-nez v2, :cond_4

    iget-object v12, v0, Lr/d;->d:Ls/k;

    :goto_4
    iget-object v12, v12, Ls/o;->i:Ls/f;

    goto :goto_5

    :cond_4
    iget-object v12, v0, Lr/d;->e:Ls/m;

    goto :goto_4

    :goto_5
    iget-object v13, v10, Ls/o;->h:Ls/f;

    iget-object v13, v13, Ls/f;->l:Ljava/util/ArrayList;

    invoke-virtual {v13, v11}, Ljava/util/ArrayList;->contains(Ljava/lang/Object;)Z

    move-result v11

    iget-object v13, v10, Ls/o;->i:Ls/f;

    iget-object v14, v13, Ls/f;->l:Ljava/util/ArrayList;

    invoke-virtual {v14, v12}, Ljava/util/ArrayList;->contains(Ljava/lang/Object;)Z

    move-result v12

    invoke-virtual {v10}, Ls/o;->j()J

    move-result-wide v14

    iget-object v5, v10, Ls/o;->h:Ls/f;

    if-eqz v11, :cond_a

    if-eqz v12, :cond_a

    const-wide/16 v0, 0x0

    invoke-static {v5, v0, v1}, Ls/l;->b(Ls/f;J)J

    move-result-wide v11

    move-object v6, v3

    move/from16 v16, v4

    invoke-static {v13, v0, v1}, Ls/l;->a(Ls/f;J)J

    move-result-wide v3

    sub-long/2addr v11, v14

    iget v0, v13, Ls/f;->f:I

    neg-int v1, v0

    move-object/from16 v18, v6

    move/from16 v17, v7

    int-to-long v6, v1

    cmp-long v1, v11, v6

    if-ltz v1, :cond_5

    int-to-long v0, v0

    add-long/2addr v11, v0

    :cond_5
    neg-long v0, v3

    sub-long/2addr v0, v14

    iget v3, v5, Ls/f;->f:I

    int-to-long v3, v3

    sub-long/2addr v0, v3

    cmp-long v6, v0, v3

    if-ltz v6, :cond_6

    sub-long/2addr v0, v3

    :cond_6
    iget-object v3, v10, Ls/o;->b:Lr/d;

    if-nez v2, :cond_7

    iget v3, v3, Lr/d;->d0:F

    goto :goto_6

    :cond_7
    const/4 v4, 0x1

    if-ne v2, v4, :cond_8

    iget v3, v3, Lr/d;->e0:F

    goto :goto_6

    :cond_8
    invoke-virtual {v3}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    const/high16 v3, -0x40800000    # -1.0f

    :goto_6
    const/4 v4, 0x0

    cmpl-float v4, v3, v4

    const/high16 v6, 0x3f800000    # 1.0f

    if-lez v4, :cond_9

    long-to-float v0, v0

    div-float/2addr v0, v3

    long-to-float v1, v11

    sub-float v4, v6, v3

    div-float/2addr v1, v4

    add-float/2addr v1, v0

    float-to-long v0, v1

    goto :goto_7

    :cond_9
    const-wide/16 v0, 0x0

    :goto_7
    long-to-float v0, v0

    mul-float v1, v0, v3

    const/high16 v4, 0x3f000000    # 0.5f

    add-float/2addr v1, v4

    float-to-long v10, v1

    sub-float/2addr v6, v3

    mul-float/2addr v6, v0

    add-float/2addr v6, v4

    float-to-long v0, v6

    add-long/2addr v10, v14

    add-long/2addr v10, v0

    iget v0, v5, Ls/f;->f:I

    int-to-long v0, v0

    add-long/2addr v0, v10

    iget v3, v13, Ls/f;->f:I

    int-to-long v3, v3

    sub-long/2addr v0, v3

    goto :goto_8

    :cond_a
    move-object/from16 v18, v3

    move/from16 v16, v4

    move/from16 v17, v7

    if-eqz v11, :cond_b

    iget v0, v5, Ls/f;->f:I

    int-to-long v0, v0

    invoke-static {v5, v0, v1}, Ls/l;->b(Ls/f;J)J

    move-result-wide v0

    iget v3, v5, Ls/f;->f:I

    int-to-long v3, v3

    add-long/2addr v3, v14

    invoke-static {v0, v1, v3, v4}, Ljava/lang/Math;->max(JJ)J

    move-result-wide v0

    goto :goto_8

    :cond_b
    if-eqz v12, :cond_c

    iget v0, v13, Ls/f;->f:I

    int-to-long v0, v0

    invoke-static {v13, v0, v1}, Ls/l;->a(Ls/f;J)J

    move-result-wide v0

    iget v3, v13, Ls/f;->f:I

    neg-int v3, v3

    int-to-long v3, v3

    add-long/2addr v3, v14

    neg-long v0, v0

    invoke-static {v0, v1, v3, v4}, Ljava/lang/Math;->max(JJ)J

    move-result-wide v0

    goto :goto_8

    :cond_c
    iget v0, v5, Ls/f;->f:I

    int-to-long v0, v0

    invoke-virtual {v10}, Ls/o;->j()J

    move-result-wide v3

    add-long/2addr v3, v0

    iget v0, v13, Ls/f;->f:I

    int-to-long v0, v0

    sub-long v0, v3, v0

    :goto_8
    invoke-static {v8, v9, v0, v1}, Ljava/lang/Math;->max(JJ)J

    move-result-wide v8

    add-int/lit8 v7, v17, 0x1

    move-object/from16 v1, p0

    move-object/from16 v0, p1

    move/from16 v4, v16

    move-object/from16 v3, v18

    goto/16 :goto_0

    :cond_d
    long-to-int v0, v8

    return v0
.end method

.method public final e(Ls/o;ILjava/util/ArrayList;)V
    .locals 4

    iget-object v0, p1, Ls/o;->h:Ls/f;

    iget-object v0, v0, Ls/f;->k:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_0
    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    iget-object v2, p1, Ls/o;->i:Ls/f;

    const/4 v3, 0x0

    if-eqz v1, :cond_2

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ls/d;

    instance-of v2, v1, Ls/f;

    if-eqz v2, :cond_1

    check-cast v1, Ls/f;

    invoke-virtual {p0, v1, p2, p3, v3}, Ls/e;->a(Ls/f;ILjava/util/ArrayList;Ls/l;)V

    goto :goto_0

    :cond_1
    instance-of v2, v1, Ls/o;

    if-eqz v2, :cond_0

    check-cast v1, Ls/o;

    iget-object v1, v1, Ls/o;->h:Ls/f;

    invoke-virtual {p0, v1, p2, p3, v3}, Ls/e;->a(Ls/f;ILjava/util/ArrayList;Ls/l;)V

    goto :goto_0

    :cond_2
    iget-object v0, v2, Ls/f;->k:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_3
    :goto_1
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_5

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ls/d;

    instance-of v2, v1, Ls/f;

    if-eqz v2, :cond_4

    check-cast v1, Ls/f;

    invoke-virtual {p0, v1, p2, p3, v3}, Ls/e;->a(Ls/f;ILjava/util/ArrayList;Ls/l;)V

    goto :goto_1

    :cond_4
    instance-of v2, v1, Ls/o;

    if-eqz v2, :cond_3

    check-cast v1, Ls/o;

    iget-object v1, v1, Ls/o;->i:Ls/f;

    invoke-virtual {p0, v1, p2, p3, v3}, Ls/e;->a(Ls/f;ILjava/util/ArrayList;Ls/l;)V

    goto :goto_1

    :cond_5
    const/4 v0, 0x1

    if-ne p2, v0, :cond_7

    check-cast p1, Ls/m;

    iget-object p1, p1, Ls/m;->k:Ls/f;

    iget-object p1, p1, Ls/f;->k:Ljava/util/ArrayList;

    invoke-virtual {p1}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :cond_6
    :goto_2
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_7

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ls/d;

    instance-of v1, v0, Ls/f;

    if-eqz v1, :cond_6

    check-cast v0, Ls/f;

    invoke-virtual {p0, v0, p2, p3, v3}, Ls/e;->a(Ls/f;ILjava/util/ArrayList;Ls/l;)V

    goto :goto_2

    :cond_7
    return-void
.end method

.method public final f(IIIILr/d;)V
    .locals 1

    iget-object v0, p0, Ls/e;->g:Ls/b;

    iput p1, v0, Ls/b;->a:I

    iput p3, v0, Ls/b;->b:I

    iput p2, v0, Ls/b;->c:I

    iput p4, v0, Ls/b;->d:I

    iget-object p1, p0, Ls/e;->f:Lu/f;

    invoke-virtual {p1, p5, v0}, Lu/f;->b(Lr/d;Ls/b;)V

    iget p1, v0, Ls/b;->e:I

    invoke-virtual {p5, p1}, Lr/d;->O(I)V

    iget p1, v0, Ls/b;->f:I

    invoke-virtual {p5, p1}, Lr/d;->L(I)V

    iget-boolean p1, v0, Ls/b;->h:Z

    iput-boolean p1, p5, Lr/d;->E:Z

    iget p1, v0, Ls/b;->g:I

    invoke-virtual {p5, p1}, Lr/d;->I(I)V

    return-void
.end method

.method public final g()V
    .locals 14

    iget-object v0, p0, Ls/e;->a:Lr/e;

    iget-object v0, v0, Lr/e;->q0:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_0
    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_b

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lr/d;

    iget-boolean v2, v1, Lr/d;->a:Z

    if-eqz v2, :cond_1

    goto :goto_0

    :cond_1
    iget-object v2, v1, Lr/d;->p0:[I

    const/4 v3, 0x0

    aget v8, v2, v3

    const/4 v9, 0x1

    aget v10, v2, v9

    iget v2, v1, Lr/d;->r:I

    iget v4, v1, Lr/d;->s:I

    const/4 v5, 0x2

    const/4 v11, 0x3

    if-eq v8, v5, :cond_3

    if-ne v8, v11, :cond_2

    if-ne v2, v9, :cond_2

    goto :goto_1

    :cond_2
    move v2, v3

    goto :goto_2

    :cond_3
    :goto_1
    move v2, v9

    :goto_2
    if-eq v10, v5, :cond_4

    if-ne v10, v11, :cond_5

    if-ne v4, v9, :cond_5

    :cond_4
    move v3, v9

    :cond_5
    iget-object v4, v1, Lr/d;->d:Ls/k;

    iget-object v4, v4, Ls/o;->e:Ls/g;

    iget-boolean v6, v4, Ls/f;->j:Z

    iget-object v7, v1, Lr/d;->e:Ls/m;

    iget-object v7, v7, Ls/o;->e:Ls/g;

    iget-boolean v12, v7, Ls/f;->j:Z

    const/4 v13, 0x1

    if-eqz v6, :cond_6

    if-eqz v12, :cond_6

    iget v4, v4, Ls/f;->g:I

    iget v6, v7, Ls/f;->g:I

    move-object v2, p0

    move v3, v13

    move v5, v13

    move-object v7, v1

    invoke-virtual/range {v2 .. v7}, Ls/e;->f(IIIILr/d;)V

    iput-boolean v9, v1, Lr/d;->a:Z

    goto :goto_3

    :cond_6
    if-eqz v6, :cond_8

    if-eqz v3, :cond_8

    iget v4, v4, Ls/f;->g:I

    iget v6, v7, Ls/f;->g:I

    move-object v2, p0

    move v3, v13

    move-object v7, v1

    invoke-virtual/range {v2 .. v7}, Ls/e;->f(IIIILr/d;)V

    if-ne v10, v11, :cond_7

    iget-object v2, v1, Lr/d;->e:Ls/m;

    iget-object v2, v2, Ls/o;->e:Ls/g;

    invoke-virtual {v1}, Lr/d;->k()I

    move-result v3

    iput v3, v2, Ls/g;->m:I

    goto :goto_3

    :cond_7
    iget-object v2, v1, Lr/d;->e:Ls/m;

    iget-object v2, v2, Ls/o;->e:Ls/g;

    invoke-virtual {v1}, Lr/d;->k()I

    move-result v3

    invoke-virtual {v2, v3}, Ls/g;->d(I)V

    iput-boolean v9, v1, Lr/d;->a:Z

    goto :goto_3

    :cond_8
    if-eqz v12, :cond_a

    if-eqz v2, :cond_a

    iget v4, v4, Ls/f;->g:I

    iget v6, v7, Ls/f;->g:I

    move-object v2, p0

    move v3, v5

    move v5, v13

    move-object v7, v1

    invoke-virtual/range {v2 .. v7}, Ls/e;->f(IIIILr/d;)V

    if-ne v8, v11, :cond_9

    iget-object v2, v1, Lr/d;->d:Ls/k;

    iget-object v2, v2, Ls/o;->e:Ls/g;

    invoke-virtual {v1}, Lr/d;->q()I

    move-result v3

    iput v3, v2, Ls/g;->m:I

    goto :goto_3

    :cond_9
    iget-object v2, v1, Lr/d;->d:Ls/k;

    iget-object v2, v2, Ls/o;->e:Ls/g;

    invoke-virtual {v1}, Lr/d;->q()I

    move-result v3

    invoke-virtual {v2, v3}, Ls/g;->d(I)V

    iput-boolean v9, v1, Lr/d;->a:Z

    :cond_a
    :goto_3
    iget-boolean v2, v1, Lr/d;->a:Z

    if-eqz v2, :cond_0

    iget-object v2, v1, Lr/d;->e:Ls/m;

    iget-object v2, v2, Ls/m;->l:Ls/a;

    if-eqz v2, :cond_0

    iget v1, v1, Lr/d;->a0:I

    invoke-virtual {v2, v1}, Ls/g;->d(I)V

    goto/16 :goto_0

    :cond_b
    return-void
.end method
