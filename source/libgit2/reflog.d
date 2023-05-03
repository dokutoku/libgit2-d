/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
/**
 * License: GPL-2.0(Linking Exception)
 */
module libgit2.reflog;


private static import libgit2.oid;
private static import libgit2.types;
private import libgit2.common: GIT_EXTERN;

/*
 * @file git2/reflog.h
 * @brief Git reflog management routines
 * @defgroup git_reflog Git reflog management routines
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

/**
 * Read the reflog for the given reference
 *
 * If there is no reflog file for the given
 * reference yet, an empty reflog object will
 * be returned.
 *
 * The reflog must be freed manually by using
 * git_reflog_free().
 *
 * Params:
 *      out_ = pointer to reflog
 *      repo = the repostiory
 *      name = reference to look up
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_reflog_read(libgit2.types.git_reflog** out_, libgit2.types.git_repository* repo, const (char)* name);

/**
 * Write an existing in-memory reflog object back to disk
 * using an atomic file lock.
 *
 * Params:
 *      reflog = an existing reflog object
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_reflog_write(libgit2.types.git_reflog* reflog);

/**
 * Add a new entry to the in-memory reflog.
 *
 * `msg` is optional and can be null.
 *
 * Params:
 *      reflog = an existing reflog object
 *      id = the OID the reference is now pointing to
 *      committer = the signature of the committer
 *      msg = the reflog message
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_reflog_append(libgit2.types.git_reflog* reflog, const (libgit2.oid.git_oid)* id, const (libgit2.types.git_signature)* committer, const (char)* msg);

/**
 * Rename a reflog
 *
 * The reflog to be renamed is expected to already exist
 *
 * The new name will be checked for validity.
 * See `git_reference_create_symbolic()` for rules about valid names.
 *
 * Params:
 *      repo = the repository
 *      old_name = the old name of the reference
 *      name = the new name of the reference
 *
 * Returns: 0 on success, git_error_code.GIT_EINVALIDSPEC or an error code
 */
@GIT_EXTERN
int git_reflog_rename(libgit2.types.git_repository* repo, const (char)* old_name, const (char)* name);

/**
 * Delete the reflog for the given reference
 *
 * Params:
 *      repo = the repository
 *      name = the reflog to delete
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_reflog_delete(libgit2.types.git_repository* repo, const (char)* name);

/**
 * Get the number of log entries in a reflog
 *
 * Params:
 *      reflog = the previously loaded reflog
 *
 * Returns: the number of log entries
 */
@GIT_EXTERN
size_t git_reflog_entrycount(libgit2.types.git_reflog* reflog);

/**
 * Lookup an entry by its index
 *
 * Requesting the reflog entry with an index of 0 (zero) will
 * return the most recently created entry.
 *
 * Params:
 *      reflog = a previously loaded reflog
 *      idx = the position of the entry to lookup. Should be greater than or equal to 0 (zero) and less than `git_reflog_entrycount()`.
 *
 * Returns: the entry; null if not found
 */
@GIT_EXTERN
const (libgit2.types.git_reflog_entry)* git_reflog_entry_byindex(const (libgit2.types.git_reflog)* reflog, size_t idx);

/**
 * Remove an entry from the reflog by its index
 *
 * To ensure there's no gap in the log history, set `rewrite_previous_entry`
 * param value to 1. When deleting entry `n`, member old_oid of entry `n-1`
 * (if any) will be updated with the value of member new_oid of entry `n+1`.
 *
 * Params:
 *      reflog = a previously loaded reflog.
 *      idx = the position of the entry to remove. Should be greater than or equal to 0 (zero) and less than `git_reflog_entrycount()`.
 *      rewrite_previous_entry = 1 to rewrite the history; 0 otherwise.
 *
 * Returns: 0 on success, git_error_code.GIT_ENOTFOUND if the entry doesn't exist or an error code.
 */
@GIT_EXTERN
int git_reflog_drop(libgit2.types.git_reflog* reflog, size_t idx, int rewrite_previous_entry);

/**
 * Get the old oid
 *
 * Params:
 *      entry = a reflog entry
 *
 * Returns: the old oid
 */
@GIT_EXTERN
const (libgit2.oid.git_oid)* git_reflog_entry_id_old(const (libgit2.types.git_reflog_entry)* entry);

/**
 * Get the new oid
 *
 * Params:
 *      entry = a reflog entry
 *
 * Returns: the new oid at this time
 */
@GIT_EXTERN
const (libgit2.oid.git_oid)* git_reflog_entry_id_new(const (libgit2.types.git_reflog_entry)* entry);

/**
 * Get the committer of this entry
 *
 * Params:
 *      entry = a reflog entry
 *
 * Returns: the committer
 */
@GIT_EXTERN
const (libgit2.types.git_signature)* git_reflog_entry_committer(const (libgit2.types.git_reflog_entry)* entry);

/**
 * Get the log message
 *
 * Params:
 *      entry = a reflog entry
 *
 * Returns: the log msg
 */
@GIT_EXTERN
const (char)* git_reflog_entry_message(const (libgit2.types.git_reflog_entry)* entry);

/**
 * Free the reflog
 *
 * Params:
 *      reflog = reflog to free
 */
@GIT_EXTERN
void git_reflog_free(libgit2.types.git_reflog* reflog);

/* @} */
