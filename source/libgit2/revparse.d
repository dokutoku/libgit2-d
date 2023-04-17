/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2.revparse;


private static import libgit2.types;
private import libgit2.common: GIT_EXTERN;

/*
 * @file git2/revparse.h
 * @brief Git revision parsing routines
 * @defgroup git_revparse Git revision parsing routines
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

/**
 * Find a single object, as specified by a revision string.
 *
 * See `man gitrevisions`, or
 * http://git-scm.com/docs/git-rev-parse.html#_specifying_revisions for
 * information on the syntax accepted.
 *
 * The returned object should be released with `git_object_free` when no
 * longer needed.
 *
 * Params:
 *      out_ = pointer to output object
 *      repo = the repository to search in
 *      spec = the textual specification for an object
 *
 * Returns: 0 on success, git_error_code.GIT_ENOTFOUND, git_error_code.GIT_EAMBIGUOUS, git_error_code.GIT_EINVALIDSPEC or an error code
 */
@GIT_EXTERN
int git_revparse_single(libgit2.types.git_object** out_, libgit2.types.git_repository* repo, const (char)* spec);

/**
 * Find a single object and intermediate reference by a revision string.
 *
 * See `man gitrevisions`, or
 * http://git-scm.com/docs/git-rev-parse.html#_specifying_revisions for
 * information on the syntax accepted.
 *
 * In some cases (`@{<-n>}` or `<branchname>@{upstream}`), the expression may
 * point to an intermediate reference. When such expressions are being passed
 * in, `reference_out` will be valued as well.
 *
 * The returned object should be released with `git_object_free` and the
 * returned reference with `git_reference_free` when no longer needed.
 *
 * Params:
 *      object_out = pointer to output object
 *      reference_out = pointer to output reference or null
 *      repo = the repository to search in
 *      spec = the textual specification for an object
 *
 * Returns: 0 on success, git_error_code.GIT_ENOTFOUND, git_error_code.GIT_EAMBIGUOUS, git_error_code.GIT_EINVALIDSPEC or an error code
 */
@GIT_EXTERN
int git_revparse_ext(libgit2.types.git_object** object_out, libgit2.types.git_reference** reference_out, libgit2.types.git_repository* repo, const (char)* spec);

/**
 * Revparse flags.  These indicate the intended behavior of the spec passed to
 * git_revparse.
 */
enum git_revparse_mode_t
{
	/**
	 * The spec targeted a single object.
	 */
	GIT_REVPARSE_SINGLE = 1 << 0,

	/**
	 * The spec targeted a range of commits.
	 */
	GIT_REVPARSE_RANGE = 1 << 1,

	/**
	 * The spec used the '...' operator, which invokes special semantics.
	 */
	GIT_REVPARSE_MERGE_BASE = 1 << 2,
}

//Declaration name in C language
enum
{
	GIT_REVPARSE_SINGLE = .git_revparse_mode_t.GIT_REVPARSE_SINGLE,
	GIT_REVPARSE_RANGE = .git_revparse_mode_t.GIT_REVPARSE_RANGE,
	GIT_REVPARSE_MERGE_BASE = .git_revparse_mode_t.GIT_REVPARSE_MERGE_BASE,
}

/**
 * Git Revision Spec: output of a `git_revparse` operation
 */
struct git_revspec
{
	/**
	 * The left element of the revspec; must be freed by the user
	 */
	libgit2.types.git_object* from;

	/**
	 * The right element of the revspec; must be freed by the user
	 */
	libgit2.types.git_object* to;

	/**
	 * The intent of the revspec (i.e. `git_revparse_mode_t` flags)
	 */
	uint flags;
}

/**
 * Parse a revision string for `from`, `to`, and intent.
 *
 * See `man gitrevisions` or
 * http://git-scm.com/docs/git-rev-parse.html#_specifying_revisions for
 * information on the syntax accepted.
 *
 * Params:
 *      revspec = Pointer to an user-allocated git_revspec struct where the result of the rev-parse will be stored
 *      repo = the repository to search in
 *      spec = the rev-parse spec to parse
 *
 * Returns: 0 on success, GIT_INVALIDSPEC, git_error_code.GIT_ENOTFOUND, git_error_code.GIT_EAMBIGUOUS or an error code
 */
@GIT_EXTERN
int git_revparse(.git_revspec* revspec, libgit2.types.git_repository* repo, const (char)* spec);

/* @} */
