.class public final LX/a;
.super LX/b;
.source "SourceFile"


# static fields
.field public static final b:LX/a;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    new-instance v0, LX/a;

    invoke-direct {v0}, LX/b;-><init>()V

    sput-object v0, LX/a;->b:LX/a;

    return-void
.end method
