/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2.sys.index;


private static import libgit2.oid;
private static import libgit2.types;
private import libgit2.common: GIT_EXTERN;

/*
 * @file git2/sys/index.h
 * @brief Low-level Git index manipulation routines
 * @defgroup git_backend Git custom backend APIs
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
package(libgit2):

/**
 * Representation of a rename conflict entry in the index.
 */
struct git_index_name_entry
{
	char* ancestor;
	char* ours;
	char* theirs;
}

/**
 * Representation of a resolve undo entry in the index.
 */
struct git_index_reuc_entry
{
	uint[3] mode;
	libgit2.oid.git_oid[3] oid;
	char* path;
}

/*
 * @name Conflict Name entry functions
 *
 * These functions work on rename conflict entries.
 */
/*@{*/

/**
 * Get the count of filename conflict entries currently in the index.
 *
 * Params:
 *      index = an existing index object
 *
 * Returns: integer of count of current filename conflict entries
 */
@GIT_EXTERN
size_t git_index_name_entrycount(libgit2.types.git_index* index);

/**
 * Get a filename conflict entry from the index.
 *
 * The returned entry is read-only and should not be modified
 * or freed by the caller.
 *
 * Params:
 *      index = an existing index object
 *      n = the position of the entry
 *
 * Returns: a pointer to the filename conflict entry; null if out of bounds
 */
@GIT_EXTERN
const (.git_index_name_entry)* git_index_name_get_byindex(libgit2.types.git_index* index, size_t n);

/**
 * Record the filenames involved in a rename conflict.
 *
 * Params:
 *      index = an existing index object
 *      ancestor = the path of the file as it existed in the ancestor
 *      ours = the path of the file as it existed in our tree
 *      theirs = the path of the file as it existed in their tree
 */
@GIT_EXTERN
int git_index_name_add(libgit2.types.git_index* index, const (char)* ancestor, const (char)* ours, const (char)* theirs);

/**
 * Remove all filename conflict entries.
 *
 * Params:
 *      index = an existing index object
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_index_name_clear(libgit2.types.git_index* index);

/*@}*/

/*
 * @name Resolve Undo (REUC) index entry manipulation.
 *
 * These functions work on the Resolve Undo index extension and contains
 * data about the original files that led to a merge conflict.
 */
/*@{*/

/**
 * Get the count of resolve undo entries currently in the index.
 *
 * Params:
 *      index = an existing index object
 *
 * Returns: integer of count of current resolve undo entries
 */
@GIT_EXTERN
size_t git_index_reuc_entrycount(libgit2.types.git_index* index);

/**
 * Finds the resolve undo entry that points to the given path in the Git
 * index.
 *
 * Params:
 *      at_pos = the address to which the position of the reuc entry is written (optional)
 *      index = an existing index object
 *      path = path to search
 *
 * Returns: 0 if found, < 0 otherwise (git_error_code.GIT_ENOTFOUND)
 */
@GIT_EXTERN
int git_index_reuc_find(size_t* at_pos, libgit2.types.git_index* index, const (char)* path);

/**
 * Get a resolve undo entry from the index.
 *
 * The returned entry is read-only and should not be modified
 * or freed by the caller.
 *
 * Params:
 *      index = an existing index object
 *      path = path to search
 *
 * Returns: the resolve undo entry; null if not found
 */
@GIT_EXTERN
const (.git_index_reuc_entry)* git_index_reuc_get_bypath(libgit2.types.git_index* index, const (char)* path);

/**
 * Get a resolve undo entry from the index.
 *
 * The returned entry is read-only and should not be modified
 * or freed by the caller.
 *
 * Params:
 *      index = an existing index object
 *      n = the position of the entry
 *
 * Returns: a pointer to the resolve undo entry; null if out of bounds
 */
@GIT_EXTERN
const (.git_index_reuc_entry)* git_index_reuc_get_byindex(libgit2.types.git_index* index, size_t n);

/**
 * Adds a resolve undo entry for a file based on the given parameters.
 *
 * The resolve undo entry contains the OIDs of files that were involved
 * in a merge conflict after the conflict has been resolved.  This allows
 * conflicts to be re-resolved later.
 *
 * If there exists a resolve undo entry for the given path in the index,
 * it will be removed.
 *
 * This method will fail in bare index instances.
 *
 * Params:
 *      index = an existing index object
 *      path = filename to add
 *      ancestor_mode = mode of the ancestor file
 *      ancestor_id = oid of the ancestor file
 *      our_mode = mode of our file
 *      our_id = oid of our file
 *      their_mode = mode of their file
 *      their_id = oid of their file
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_index_reuc_add(libgit2.types.git_index* index, const (char)* path, int ancestor_mode, const (libgit2.oid.git_oid)* ancestor_id, int our_mode, const (libgit2.oid.git_oid)* our_id, int their_mode, const (libgit2.oid.git_oid)* their_id);

/**
 * Remove an resolve undo entry from the index
 *
 * Params:
 *      index = an existing index object
 *      n = position of the resolve undo entry to remove
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_index_reuc_remove(libgit2.types.git_index* index, size_t n);

/**
 * Remove all resolve undo entries from the index
 *
 * Params:
 *      index = an existing index object
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_index_reuc_clear(libgit2.types.git_index* index);

/*@}*/

/* @} */
