.class public final Lf0/o;
.super Lf0/n;
.source "SourceFile"


# instance fields
.field public final synthetic a:Ln/b;

.field public final synthetic b:Lf0/p;


# direct methods
.method public constructor <init>(Lf0/p;Ln/b;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lf0/o;->b:Lf0/p;

    iput-object p2, p0, Lf0/o;->a:Ln/b;

    return-void
.end method


# virtual methods
.method public final b(Lf0/m;)V
    .locals 3

    iget-object v0, p0, Lf0/o;->b:Lf0/p;

    iget-object v0, v0, Lf0/p;->b:Landroid/view/ViewGroup;

    const/4 v1, 0x0

    iget-object v2, p0, Lf0/o;->a:Ln/b;

    invoke-virtual {v2, v0, v1}, Ln/k;->getOrDefault(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/ArrayList;

    invoke-virtual {v0, p1}, Ljava/util/ArrayList;->remove(Ljava/lang/Object;)Z

    invoke-virtual {p1, p0}, Lf0/m;->x(Lf0/k;)Lf0/m;

    return-void
.end method
