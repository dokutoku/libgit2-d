/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2_d.transaction;


private static import libgit2_d.oid;
private static import libgit2_d.types;

/*
 * @file git2/transaction.h
 * @brief Git transactional reference routines
 * @defgroup git_transaction Git transactional reference routines
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

/**
 * Create a new transaction object
 *
 * This does not lock anything, but sets up the transaction object to
 * know from which repository to lock.
 *
 * Params:
 *      out_ = the resulting transaction
 *      repo = the repository in which to lock
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_transaction_new(libgit2_d.types.git_transaction** out_, libgit2_d.types.git_repository* repo);

/**
 * Lock a reference
 *
 * Lock the specified reference. This is the first step to updating a
 * reference.
 *
 * Params:
 *      tx = the transaction
 *      refname = the reference to lock
 *
 * Returns: 0 or an error message
 */
//GIT_EXTERN
int git_transaction_lock_ref(libgit2_d.types.git_transaction* tx, const (char)* refname);

/**
 * Set the target of a reference
 *
 * Set the target of the specified reference. This reference must be
 * locked.
 *
 * Params:
 *      tx = the transaction
 *      refname = reference to update
 *      target = target to set the reference to
 *      sig = signature to use in the reflog; pass null to read the identity from the config
 *      msg = message to use in the reflog
 *
 * Returns: 0, git_error_code.GIT_ENOTFOUND if the reference is not among the locked ones, or an error code
 */
//GIT_EXTERN
int git_transaction_set_target(libgit2_d.types.git_transaction* tx, const (char)* refname, const (libgit2_d.oid.git_oid)* target, const (libgit2_d.types.git_signature)* sig, const (char)* msg);

/**
 * Set the target of a reference
 *
 * Set the target of the specified reference. This reference must be
 * locked.
 *
 * Params:
 *      tx = the transaction
 *      refname = reference to update
 *      target = target to set the reference to
 *      sig = signature to use in the reflog; pass null to read the identity from the config
 *      msg = message to use in the reflog
 *
 * Returns: 0, git_error_code.GIT_ENOTFOUND if the reference is not among the locked ones, or an error code
 */
//GIT_EXTERN
int git_transaction_set_symbolic_target(libgit2_d.types.git_transaction* tx, const (char)* refname, const (char)* target, const (libgit2_d.types.git_signature)* sig, const (char)* msg);

/**
 * Set the reflog of a reference
 *
 * Set the specified reference's reflog. If this is combined with
 * setting the target, that update won't be written to the reflog.
 *
 * Params:
 *      tx = the transaction
 *      refname = the reference whose reflog to set
 *      reflog = the reflog as it should be written out
 *
 * Returns: 0, git_error_code.GIT_ENOTFOUND if the reference is not among the locked ones, or an error code
 */
//GIT_EXTERN
int git_transaction_set_reflog(libgit2_d.types.git_transaction* tx, const (char)* refname, const (libgit2_d.types.git_reflog)* reflog);

/**
 * Remove a reference
 *
 * Params:
 *      tx = the transaction
 *      refname = the reference to remove
 *
 * Returns: 0, git_error_code.GIT_ENOTFOUND if the reference is not among the locked ones, or an error code
 */
//GIT_EXTERN
int git_transaction_remove(libgit2_d.types.git_transaction* tx, const (char)* refname);

/**
 * Commit the changes from the transaction
 *
 * Perform the changes that have been queued. The updates will be made
 * one by one, and the first failure will stop the processing.
 *
 * Params:
 *      tx = the transaction
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_transaction_commit(libgit2_d.types.git_transaction* tx);

/**
 * Free the resources allocated by this transaction
 *
 * If any references remain locked, they will be unlocked without any
 * changes made to them.
 *
 * Params:
 *      tx = the transaction
 */
//GIT_EXTERN
void git_transaction_free(libgit2_d.types.git_transaction* tx);

/* @} */
