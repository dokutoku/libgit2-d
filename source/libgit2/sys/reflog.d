/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
/**
 * License: GPL-2.0(Linking Exception)
 */
module libgit2.sys.reflog;


private static import libgit2.types;
private import libgit2.common: GIT_EXTERN;

extern (C):
nothrow @nogc:
package(libgit2):

@GIT_EXTERN
libgit2.types.git_reflog_entry* git_reflog_entry__alloc();

@GIT_EXTERN
void git_reflog_entry__free(libgit2.types.git_reflog_entry* entry);
