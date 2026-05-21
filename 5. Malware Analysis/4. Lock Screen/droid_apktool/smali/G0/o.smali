.class public final LG0/o;
.super Lx0/j;
.source "SourceFile"


# instance fields
.field public final synthetic a:LG0/s;


# direct methods
.method public constructor <init>(LG0/s;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, LG0/o;->a:LG0/s;

    return-void
.end method


# virtual methods
.method public final afterTextChanged(Landroid/text/Editable;)V
    .locals 0

    iget-object p1, p0, LG0/o;->a:LG0/s;

    invoke-virtual {p1}, LG0/s;->b()LG0/t;

    move-result-object p1

    invoke-virtual {p1}, LG0/t;->a()V

    return-void
.end method

.method public final beforeTextChanged(Ljava/lang/CharSequence;III)V
    .locals 0

    iget-object p1, p0, LG0/o;->a:LG0/s;

    invoke-virtual {p1}, LG0/s;->b()LG0/t;

    move-result-object p1

    invoke-virtual {p1}, LG0/t;->b()V

    return-void
.end method
