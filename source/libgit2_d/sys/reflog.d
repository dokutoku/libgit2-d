/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2_d.sys.reflog;


private static import libgit2_d.types;

extern (C):
nothrow @nogc:
package(libgit2_d):

//GIT_EXTERN
libgit2_d.types.git_reflog_entry* git_reflog_entry__alloc();

//GIT_EXTERN
void git_reflog_entry__free(libgit2_d.types.git_reflog_entry* entry);
