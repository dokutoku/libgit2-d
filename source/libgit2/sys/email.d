/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
/**
 * License: GPL-2.0(Linking Exception)
 */
module libgit2.sys.email;


private static import libgit2.buffer;
private static import libgit2.diff;
private static import libgit2.email;
private static import libgit2.oid;
private static import libgit2.types;
private import libgit2.common: GIT_EXTERN;

/*
 * @file git2/sys/email.h
 * @brief Advanced git email creation routines
 * @defgroup git_email Advanced git email creation routines
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:

/**
 * Create a diff for a commit in mbox format for sending via email.
 *
 * Params:
 *      out_ = buffer to store the e-mail patch in
 *      diff = the changes to include in the email
 *      patch_idx = the patch index
 *      patch_count = the total number of patches that will be included
 *      commit_id = the commit id for this change
 *      summary = the commit message for this change
 *      body_ = optional text to include above the diffstat
 *      author = the person who authored this commit
 *      opts = email creation options
 */
@GIT_EXTERN
int git_email_create_from_diff(libgit2.buffer.git_buf* out_, libgit2.diff.git_diff* diff, size_t patch_idx, size_t patch_count, const (libgit2.oid.git_oid)* commit_id, const (char)* summary, const (char)* body_, const (libgit2.types.git_signature)* author, const (libgit2.email.git_email_create_options)* opts);

/* @} */
