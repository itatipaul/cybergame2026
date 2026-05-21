.class public final synthetic LG0/k;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Landroid/widget/AutoCompleteTextView$OnDismissListener;


# instance fields
.field public final synthetic a:LG0/n;


# direct methods
.method public synthetic constructor <init>(LG0/n;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, LG0/k;->a:LG0/n;

    return-void
.end method


# virtual methods
.method public final onDismiss()V
    .locals 4

    const/4 v0, 0x1

    iget-object v1, p0, LG0/k;->a:LG0/n;

    iput-boolean v0, v1, LG0/n;->m:Z

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    iput-wide v2, v1, LG0/n;->o:J

    const/4 v0, 0x0

    invoke-virtual {v1, v0}, LG0/n;->t(Z)V

    return-void
.end method
