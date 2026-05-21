.class public final Lu/i;
.super Ljava/lang/Object;
.source "SourceFile"


# instance fields
.field public a:I

.field public final b:Lu/l;

.field public final c:Lu/k;

.field public final d:Lu/j;

.field public final e:Lu/m;

.field public f:Ljava/util/HashMap;


# direct methods
.method public constructor <init>()V
    .locals 9

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    new-instance v0, Lu/l;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    const/4 v1, 0x0

    iput v1, v0, Lu/l;->a:I

    iput v1, v0, Lu/l;->b:I

    const/high16 v2, 0x3f800000    # 1.0f

    iput v2, v0, Lu/l;->c:F

    const/high16 v3, 0x7fc00000    # Float.NaN

    iput v3, v0, Lu/l;->d:F

    iput-object v0, p0, Lu/i;->b:Lu/l;

    new-instance v0, Lu/k;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    const/4 v4, -0x1

    iput v4, v0, Lu/k;->a:I

    iput v1, v0, Lu/k;->b:I

    iput v4, v0, Lu/k;->c:I

    iput v3, v0, Lu/k;->d:F

    iput v3, v0, Lu/k;->e:F

    iput v3, v0, Lu/k;->f:F

    iput v4, v0, Lu/k;->g:I

    const/4 v5, 0x0

    iput-object v5, v0, Lu/k;->h:Ljava/lang/String;

    iput v4, v0, Lu/k;->i:I

    iput-object v0, p0, Lu/i;->c:Lu/k;

    new-instance v0, Lu/j;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    iput-boolean v1, v0, Lu/j;->a:Z

    iput v4, v0, Lu/j;->d:I

    iput v4, v0, Lu/j;->e:I

    const/high16 v6, -0x40800000    # -1.0f

    iput v6, v0, Lu/j;->f:F

    const/4 v7, 0x1

    iput-boolean v7, v0, Lu/j;->g:Z

    iput v4, v0, Lu/j;->h:I

    iput v4, v0, Lu/j;->i:I

    iput v4, v0, Lu/j;->j:I

    iput v4, v0, Lu/j;->k:I

    iput v4, v0, Lu/j;->l:I

    iput v4, v0, Lu/j;->m:I

    iput v4, v0, Lu/j;->n:I

    iput v4, v0, Lu/j;->o:I

    iput v4, v0, Lu/j;->p:I

    iput v4, v0, Lu/j;->q:I

    iput v4, v0, Lu/j;->r:I

    iput v4, v0, Lu/j;->s:I

    iput v4, v0, Lu/j;->t:I

    iput v4, v0, Lu/j;->u:I

    iput v4, v0, Lu/j;->v:I

    const/high16 v8, 0x3f000000    # 0.5f

    iput v8, v0, Lu/j;->w:F

    iput v8, v0, Lu/j;->x:F

    iput-object v5, v0, Lu/j;->y:Ljava/lang/String;

    iput v4, v0, Lu/j;->z:I

    iput v1, v0, Lu/j;->A:I

    const/4 v5, 0x0

    iput v5, v0, Lu/j;->B:F

    iput v4, v0, Lu/j;->C:I

    iput v4, v0, Lu/j;->D:I

    iput v4, v0, Lu/j;->E:I

    iput v1, v0, Lu/j;->F:I

    iput v1, v0, Lu/j;->G:I

    iput v1, v0, Lu/j;->H:I

    iput v1, v0, Lu/j;->I:I

    iput v1, v0, Lu/j;->J:I

    iput v1, v0, Lu/j;->K:I

    iput v1, v0, Lu/j;->L:I

    const/high16 v8, -0x80000000

    iput v8, v0, Lu/j;->M:I

    iput v8, v0, Lu/j;->N:I

    iput v8, v0, Lu/j;->O:I

    iput v8, v0, Lu/j;->P:I

    iput v8, v0, Lu/j;->Q:I

    iput v8, v0, Lu/j;->R:I

    iput v8, v0, Lu/j;->S:I

    iput v6, v0, Lu/j;->T:F

    iput v6, v0, Lu/j;->U:F

    iput v1, v0, Lu/j;->V:I

    iput v1, v0, Lu/j;->W:I

    iput v1, v0, Lu/j;->X:I

    iput v1, v0, Lu/j;->Y:I

    iput v1, v0, Lu/j;->Z:I

    iput v1, v0, Lu/j;->a0:I

    iput v1, v0, Lu/j;->b0:I

    iput v1, v0, Lu/j;->c0:I

    iput v2, v0, Lu/j;->d0:F

    iput v2, v0, Lu/j;->e0:F

    iput v4, v0, Lu/j;->f0:I

    iput v1, v0, Lu/j;->g0:I

    iput v4, v0, Lu/j;->h0:I

    iput-boolean v1, v0, Lu/j;->l0:Z

    iput-boolean v1, v0, Lu/j;->m0:Z

    iput-boolean v7, v0, Lu/j;->n0:Z

    iput v1, v0, Lu/j;->o0:I

    iput-object v0, p0, Lu/i;->d:Lu/j;

    new-instance v0, Lu/m;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    iput v5, v0, Lu/m;->a:F

    iput v5, v0, Lu/m;->b:F

    iput v5, v0, Lu/m;->c:F

    iput v2, v0, Lu/m;->d:F

    iput v2, v0, Lu/m;->e:F

    iput v3, v0, Lu/m;->f:F

    iput v3, v0, Lu/m;->g:F

    iput v4, v0, Lu/m;->h:I

    iput v5, v0, Lu/m;->i:F

    iput v5, v0, Lu/m;->j:F

    iput v5, v0, Lu/m;->k:F

    iput-boolean v1, v0, Lu/m;->l:Z

    iput v5, v0, Lu/m;->m:F

    iput-object v0, p0, Lu/i;->e:Lu/m;

    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    iput-object v0, p0, Lu/i;->f:Ljava/util/HashMap;

    return-void
.end method


# virtual methods
.method public final a(Lu/e;)V
    .locals 2

    iget-object v0, p0, Lu/i;->d:Lu/j;

    iget v1, v0, Lu/j;->h:I

    iput v1, p1, Lu/e;->e:I

    iget v1, v0, Lu/j;->i:I

    iput v1, p1, Lu/e;->f:I

    iget v1, v0, Lu/j;->j:I

    iput v1, p1, Lu/e;->g:I

    iget v1, v0, Lu/j;->k:I

    iput v1, p1, Lu/e;->h:I

    iget v1, v0, Lu/j;->l:I

    iput v1, p1, Lu/e;->i:I

    iget v1, v0, Lu/j;->m:I

    iput v1, p1, Lu/e;->j:I

    iget v1, v0, Lu/j;->n:I

    iput v1, p1, Lu/e;->k:I

    iget v1, v0, Lu/j;->o:I

    iput v1, p1, Lu/e;->l:I

    iget v1, v0, Lu/j;->p:I

    iput v1, p1, Lu/e;->m:I

    iget v1, v0, Lu/j;->q:I

    iput v1, p1, Lu/e;->n:I

    iget v1, v0, Lu/j;->r:I

    iput v1, p1, Lu/e;->o:I

    iget v1, v0, Lu/j;->s:I

    iput v1, p1, Lu/e;->s:I

    iget v1, v0, Lu/j;->t:I

    iput v1, p1, Lu/e;->t:I

    iget v1, v0, Lu/j;->u:I

    iput v1, p1, Lu/e;->u:I

    iget v1, v0, Lu/j;->v:I

    iput v1, p1, Lu/e;->v:I

    iget v1, v0, Lu/j;->F:I

    iput v1, p1, Landroid/view/ViewGroup$MarginLayoutParams;->leftMargin:I

    iget v1, v0, Lu/j;->G:I

    iput v1, p1, Landroid/view/ViewGroup$MarginLayoutParams;->rightMargin:I

    iget v1, v0, Lu/j;->H:I

    iput v1, p1, Landroid/view/ViewGroup$MarginLayoutParams;->topMargin:I

    iget v1, v0, Lu/j;->I:I

    iput v1, p1, Landroid/view/ViewGroup$MarginLayoutParams;->bottomMargin:I

    iget v1, v0, Lu/j;->R:I

    iput v1, p1, Lu/e;->A:I

    iget v1, v0, Lu/j;->Q:I

    iput v1, p1, Lu/e;->B:I

    iget v1, v0, Lu/j;->N:I

    iput v1, p1, Lu/e;->x:I

    iget v1, v0, Lu/j;->P:I

    iput v1, p1, Lu/e;->z:I

    iget v1, v0, Lu/j;->w:F

    iput v1, p1, Lu/e;->E:F

    iget v1, v0, Lu/j;->x:F

    iput v1, p1, Lu/e;->F:F

    iget v1, v0, Lu/j;->z:I

    iput v1, p1, Lu/e;->p:I

    iget v1, v0, Lu/j;->A:I

    iput v1, p1, Lu/e;->q:I

    iget v1, v0, Lu/j;->B:F

    iput v1, p1, Lu/e;->r:F

    iget-object v1, v0, Lu/j;->y:Ljava/lang/String;

    iput-object v1, p1, Lu/e;->G:Ljava/lang/String;

    iget v1, v0, Lu/j;->C:I

    iput v1, p1, Lu/e;->T:I

    iget v1, v0, Lu/j;->D:I

    iput v1, p1, Lu/e;->U:I

    iget v1, v0, Lu/j;->T:F

    iput v1, p1, Lu/e;->I:F

    iget v1, v0, Lu/j;->U:F

    iput v1, p1, Lu/e;->H:F

    iget v1, v0, Lu/j;->W:I

    iput v1, p1, Lu/e;->K:I

    iget v1, v0, Lu/j;->V:I

    iput v1, p1, Lu/e;->J:I

    iget-boolean v1, v0, Lu/j;->l0:Z

    iput-boolean v1, p1, Lu/e;->W:Z

    iget-boolean v1, v0, Lu/j;->m0:Z

    iput-boolean v1, p1, Lu/e;->X:Z

    iget v1, v0, Lu/j;->X:I

    iput v1, p1, Lu/e;->L:I

    iget v1, v0, Lu/j;->Y:I

    iput v1, p1, Lu/e;->M:I

    iget v1, v0, Lu/j;->Z:I

    iput v1, p1, Lu/e;->P:I

    iget v1, v0, Lu/j;->a0:I

    iput v1, p1, Lu/e;->Q:I

    iget v1, v0, Lu/j;->b0:I

    iput v1, p1, Lu/e;->N:I

    iget v1, v0, Lu/j;->c0:I

    iput v1, p1, Lu/e;->O:I

    iget v1, v0, Lu/j;->d0:F

    iput v1, p1, Lu/e;->R:F

    iget v1, v0, Lu/j;->e0:F

    iput v1, p1, Lu/e;->S:F

    iget v1, v0, Lu/j;->E:I

    iput v1, p1, Lu/e;->V:I

    iget v1, v0, Lu/j;->f:F

    iput v1, p1, Lu/e;->c:F

    iget v1, v0, Lu/j;->d:I

    iput v1, p1, Lu/e;->a:I

    iget v1, v0, Lu/j;->e:I

    iput v1, p1, Lu/e;->b:I

    iget v1, v0, Lu/j;->b:I

    iput v1, p1, Landroid/view/ViewGroup$MarginLayoutParams;->width:I

    iget v1, v0, Lu/j;->c:I

    iput v1, p1, Landroid/view/ViewGroup$MarginLayoutParams;->height:I

    iget-object v1, v0, Lu/j;->k0:Ljava/lang/String;

    if-eqz v1, :cond_0

    iput-object v1, p1, Lu/e;->Y:Ljava/lang/String;

    :cond_0
    iget v1, v0, Lu/j;->o0:I

    iput v1, p1, Lu/e;->Z:I

    iget v1, v0, Lu/j;->K:I

    invoke-virtual {p1, v1}, Landroid/view/ViewGroup$MarginLayoutParams;->setMarginStart(I)V

    iget v0, v0, Lu/j;->J:I

    invoke-virtual {p1, v0}, Landroid/view/ViewGroup$MarginLayoutParams;->setMarginEnd(I)V

    invoke-virtual {p1}, Lu/e;->a()V

    return-void
.end method

.method public final clone()Ljava/lang/Object;
    .locals 5

    new-instance v0, Lu/i;

    invoke-direct {v0}, Lu/i;-><init>()V

    iget-object v1, v0, Lu/i;->d:Lu/j;

    invoke-virtual {v1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    iget-object v2, p0, Lu/i;->d:Lu/j;

    iget-boolean v3, v2, Lu/j;->a:Z

    iput-boolean v3, v1, Lu/j;->a:Z

    iget v3, v2, Lu/j;->b:I

    iput v3, v1, Lu/j;->b:I

    iget v3, v2, Lu/j;->c:I

    iput v3, v1, Lu/j;->c:I

    iget v3, v2, Lu/j;->d:I

    iput v3, v1, Lu/j;->d:I

    iget v3, v2, Lu/j;->e:I

    iput v3, v1, Lu/j;->e:I

    iget v3, v2, Lu/j;->f:F

    iput v3, v1, Lu/j;->f:F

    iget-boolean v3, v2, Lu/j;->g:Z

    iput-boolean v3, v1, Lu/j;->g:Z

    iget v3, v2, Lu/j;->h:I

    iput v3, v1, Lu/j;->h:I

    iget v3, v2, Lu/j;->i:I

    iput v3, v1, Lu/j;->i:I

    iget v3, v2, Lu/j;->j:I

    iput v3, v1, Lu/j;->j:I

    iget v3, v2, Lu/j;->k:I

    iput v3, v1, Lu/j;->k:I

    iget v3, v2, Lu/j;->l:I

    iput v3, v1, Lu/j;->l:I

    iget v3, v2, Lu/j;->m:I

    iput v3, v1, Lu/j;->m:I

    iget v3, v2, Lu/j;->n:I

    iput v3, v1, Lu/j;->n:I

    iget v3, v2, Lu/j;->o:I

    iput v3, v1, Lu/j;->o:I

    iget v3, v2, Lu/j;->p:I

    iput v3, v1, Lu/j;->p:I

    iget v3, v2, Lu/j;->q:I

    iput v3, v1, Lu/j;->q:I

    iget v3, v2, Lu/j;->r:I

    iput v3, v1, Lu/j;->r:I

    iget v3, v2, Lu/j;->s:I

    iput v3, v1, Lu/j;->s:I

    iget v3, v2, Lu/j;->t:I

    iput v3, v1, Lu/j;->t:I

    iget v3, v2, Lu/j;->u:I

    iput v3, v1, Lu/j;->u:I

    iget v3, v2, Lu/j;->v:I

    iput v3, v1, Lu/j;->v:I

    iget v3, v2, Lu/j;->w:F

    iput v3, v1, Lu/j;->w:F

    iget v3, v2, Lu/j;->x:F

    iput v3, v1, Lu/j;->x:F

    iget-object v3, v2, Lu/j;->y:Ljava/lang/String;

    iput-object v3, v1, Lu/j;->y:Ljava/lang/String;

    iget v3, v2, Lu/j;->z:I

    iput v3, v1, Lu/j;->z:I

    iget v3, v2, Lu/j;->A:I

    iput v3, v1, Lu/j;->A:I

    iget v3, v2, Lu/j;->B:F

    iput v3, v1, Lu/j;->B:F

    iget v3, v2, Lu/j;->C:I

    iput v3, v1, Lu/j;->C:I

    iget v3, v2, Lu/j;->D:I

    iput v3, v1, Lu/j;->D:I

    iget v3, v2, Lu/j;->E:I

    iput v3, v1, Lu/j;->E:I

    iget v3, v2, Lu/j;->F:I

    iput v3, v1, Lu/j;->F:I

    iget v3, v2, Lu/j;->G:I

    iput v3, v1, Lu/j;->G:I

    iget v3, v2, Lu/j;->H:I

    iput v3, v1, Lu/j;->H:I

    iget v3, v2, Lu/j;->I:I

    iput v3, v1, Lu/j;->I:I

    iget v3, v2, Lu/j;->J:I

    iput v3, v1, Lu/j;->J:I

    iget v3, v2, Lu/j;->K:I

    iput v3, v1, Lu/j;->K:I

    iget v3, v2, Lu/j;->L:I

    iput v3, v1, Lu/j;->L:I

    iget v3, v2, Lu/j;->M:I

    iput v3, v1, Lu/j;->M:I

    iget v3, v2, Lu/j;->N:I

    iput v3, v1, Lu/j;->N:I

    iget v3, v2, Lu/j;->O:I

    iput v3, v1, Lu/j;->O:I

    iget v3, v2, Lu/j;->P:I

    iput v3, v1, Lu/j;->P:I

    iget v3, v2, Lu/j;->Q:I

    iput v3, v1, Lu/j;->Q:I

    iget v3, v2, Lu/j;->R:I

    iput v3, v1, Lu/j;->R:I

    iget v3, v2, Lu/j;->S:I

    iput v3, v1, Lu/j;->S:I

    iget v3, v2, Lu/j;->T:F

    iput v3, v1, Lu/j;->T:F

    iget v3, v2, Lu/j;->U:F

    iput v3, v1, Lu/j;->U:F

    iget v3, v2, Lu/j;->V:I

    iput v3, v1, Lu/j;->V:I

    iget v3, v2, Lu/j;->W:I

    iput v3, v1, Lu/j;->W:I

    iget v3, v2, Lu/j;->X:I

    iput v3, v1, Lu/j;->X:I

    iget v3, v2, Lu/j;->Y:I

    iput v3, v1, Lu/j;->Y:I

    iget v3, v2, Lu/j;->Z:I

    iput v3, v1, Lu/j;->Z:I

    iget v3, v2, Lu/j;->a0:I

    iput v3, v1, Lu/j;->a0:I

    iget v3, v2, Lu/j;->b0:I

    iput v3, v1, Lu/j;->b0:I

    iget v3, v2, Lu/j;->c0:I

    iput v3, v1, Lu/j;->c0:I

    iget v3, v2, Lu/j;->d0:F

    iput v3, v1, Lu/j;->d0:F

    iget v3, v2, Lu/j;->e0:F

    iput v3, v1, Lu/j;->e0:F

    iget v3, v2, Lu/j;->f0:I

    iput v3, v1, Lu/j;->f0:I

    iget v3, v2, Lu/j;->g0:I

    iput v3, v1, Lu/j;->g0:I

    iget v3, v2, Lu/j;->h0:I

    iput v3, v1, Lu/j;->h0:I

    iget-object v3, v2, Lu/j;->k0:Ljava/lang/String;

    iput-object v3, v1, Lu/j;->k0:Ljava/lang/String;

    iget-object v3, v2, Lu/j;->i0:[I

    if-eqz v3, :cond_0

    iget-object v4, v2, Lu/j;->j0:Ljava/lang/String;

    if-nez v4, :cond_0

    array-length v4, v3

    invoke-static {v3, v4}, Ljava/util/Arrays;->copyOf([II)[I

    move-result-object v3

    iput-object v3, v1, Lu/j;->i0:[I

    goto :goto_0

    :cond_0
    const/4 v3, 0x0

    iput-object v3, v1, Lu/j;->i0:[I

    :goto_0
    iget-object v3, v2, Lu/j;->j0:Ljava/lang/String;

    iput-object v3, v1, Lu/j;->j0:Ljava/lang/String;

    iget-boolean v3, v2, Lu/j;->l0:Z

    iput-boolean v3, v1, Lu/j;->l0:Z

    iget-boolean v3, v2, Lu/j;->m0:Z

    iput-boolean v3, v1, Lu/j;->m0:Z

    iget-boolean v3, v2, Lu/j;->n0:Z

    iput-boolean v3, v1, Lu/j;->n0:Z

    iget v2, v2, Lu/j;->o0:I

    iput v2, v1, Lu/j;->o0:I

    iget-object v1, v0, Lu/i;->c:Lu/k;

    invoke-virtual {v1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    iget-object v2, p0, Lu/i;->c:Lu/k;

    invoke-virtual {v2}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    iget v3, v2, Lu/k;->a:I

    iput v3, v1, Lu/k;->a:I

    iget v3, v2, Lu/k;->c:I

    iput v3, v1, Lu/k;->c:I

    iget v3, v2, Lu/k;->e:F

    iput v3, v1, Lu/k;->e:F

    iget v2, v2, Lu/k;->d:F

    iput v2, v1, Lu/k;->d:F

    iget-object v1, v0, Lu/i;->b:Lu/l;

    invoke-virtual {v1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    iget-object v2, p0, Lu/i;->b:Lu/l;

    invoke-virtual {v2}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    iget v3, v2, Lu/l;->a:I

    iput v3, v1, Lu/l;->a:I

    iget v3, v2, Lu/l;->c:F

    iput v3, v1, Lu/l;->c:F

    iget v3, v2, Lu/l;->d:F

    iput v3, v1, Lu/l;->d:F

    iget v2, v2, Lu/l;->b:I

    iput v2, v1, Lu/l;->b:I

    iget-object v1, v0, Lu/i;->e:Lu/m;

    invoke-virtual {v1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    iget-object v2, p0, Lu/i;->e:Lu/m;

    invoke-virtual {v2}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    iget v3, v2, Lu/m;->a:F

    iput v3, v1, Lu/m;->a:F

    iget v3, v2, Lu/m;->b:F

    iput v3, v1, Lu/m;->b:F

    iget v3, v2, Lu/m;->c:F

    iput v3, v1, Lu/m;->c:F

    iget v3, v2, Lu/m;->d:F

    iput v3, v1, Lu/m;->d:F

    iget v3, v2, Lu/m;->e:F

    iput v3, v1, Lu/m;->e:F

    iget v3, v2, Lu/m;->f:F

    iput v3, v1, Lu/m;->f:F

    iget v3, v2, Lu/m;->g:F

    iput v3, v1, Lu/m;->g:F

    iget v3, v2, Lu/m;->h:I

    iput v3, v1, Lu/m;->h:I

    iget v3, v2, Lu/m;->i:F

    iput v3, v1, Lu/m;->i:F

    iget v3, v2, Lu/m;->j:F

    iput v3, v1, Lu/m;->j:F

    iget v3, v2, Lu/m;->k:F

    iput v3, v1, Lu/m;->k:F

    iget-boolean v3, v2, Lu/m;->l:Z

    iput-boolean v3, v1, Lu/m;->l:Z

    iget v2, v2, Lu/m;->m:F

    iput v2, v1, Lu/m;->m:F

    iget v1, p0, Lu/i;->a:I

    iput v1, v0, Lu/i;->a:I

    return-object v0
.end method
