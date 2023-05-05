/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
/**
 * License: GPL-2.0(Linking Exception)
 */
module libgit2.graph;


private static import libgit2.oid;
private static import libgit2.types;
private import libgit2.common: GIT_EXTERN;

/*
 * @file git2/graph.h
 * @brief Git graph traversal routines
 * @defgroup git_revwalk Git graph traversal routines
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

/**
 * Count the number of unique commits between two commit objects
 *
 * There is no need for branches containing the commits to have any
 * upstream relationship, but it helps to think of one as a branch and
 * the other as its upstream, the `ahead` and `behind` values will be
 * what git would report for the branches.
 *
 * Params:
 *      ahead = number of unique from commits in `upstream`
 *      behind = number of unique from commits in `local`
 *      repo = the repository where the commits exist
 *      local = the commit for local
 *      upstream = the commit for upstream
 */
@GIT_EXTERN
int git_graph_ahead_behind(size_t* ahead, size_t* behind, libgit2.types.git_repository* repo, const (libgit2.oid.git_oid)* local, const (libgit2.oid.git_oid)* upstream);

/**
 * Determine if a commit is the descendant of another commit.
 *
 * Note that a commit is not considered a descendant of itself, in contrast
 * to `git merge-base --is-ancestor`.
 *
 * Params:
 *      repo = the repository where the commits exist
 *      commit = a previously loaded commit
 *      ancestor = a potential ancestor commit
 *
 * Returns: 1 if the given commit is a descendant of the potential ancestor, 0 if not, error code otherwise.
 */
@GIT_EXTERN
int git_graph_descendant_of(libgit2.types.git_repository* repo, const (libgit2.oid.git_oid)* commit, const (libgit2.oid.git_oid)* ancestor);

/**
 * Determine if a commit is reachable from any of a list of commits by
 * following parent edges.
 *
 * Params:
 *      repo = the repository where the commits exist
 *      commit = a previously loaded commit
 *      length = the number of commits in the provided `descendant_array`
 *      descendant_array = oids of the commits
 *
 * Returns: 1 if the given commit is an ancestor of any of the given potential descendants, 0 if not, error code otherwise.
 */
@GIT_EXTERN
int git_graph_reachable_from_any(libgit2.types.git_repository* repo, const (libgit2.oid.git_oid)* commit, const (libgit2.oid.git_oid)* descendant_array, size_t length);

/* @} */
