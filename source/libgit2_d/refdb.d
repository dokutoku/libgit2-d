/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2_d.refdb;


private static import libgit2_d.common;
private static import libgit2_d.oid;
private static import libgit2_d.refs;
private static import libgit2_d.types;

/**
 * @file git2/refdb.h
 * @brief Git custom refs backend functions
 * @defgroup git_refdb Git custom refs backend API
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:

/**
 * Create a new reference database with no backends.
 *
 * Before the Ref DB can be used for read/writing, a custom database
 * backend must be manually set using `git_refdb_set_backend()`
 *
 * @param out_ location to store the database pointer, if opened.
 *			Set to null if the open failed.
 * @param repo the repository
 * @return 0 or an error code
 */
//GIT_EXTERN
int git_refdb_new(libgit2_d.types.git_refdb** out_, libgit2_d.types.git_repository* repo);

/**
 * Create a new reference database and automatically add
 * the default backends:
 *
 *  - git_refdb_dir: read and write loose and packed refs
 *      from disk, assuming the repository dir as the folder
 *
 * @param out_ location to store the database pointer, if opened.
 *			Set to null if the open failed.
 * @param repo the repository
 * @return 0 or an error code
 */
//GIT_EXTERN
int git_refdb_open(libgit2_d.types.git_refdb** out_, libgit2_d.types.git_repository* repo);

/**
 * Suggests that the given refdb compress or optimize its references.
 * This mechanism is implementation specific.  For on-disk reference
 * databases, for example, this may pack all loose references.
 */
//GIT_EXTERN
int git_refdb_compress(libgit2_d.types.git_refdb* refdb);

/**
 * Close an open reference database.
 *
 * @param refdb reference database pointer or null
 */
//GIT_EXTERN
void git_refdb_free(libgit2_d.types.git_refdb* refdb);

/** @} */
