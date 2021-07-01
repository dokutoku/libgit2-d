/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2_d.rebase;


private static import libgit2_d.checkout;
private static import libgit2_d.commit;
private static import libgit2_d.merge;
private static import libgit2_d.oid;
private static import libgit2_d.types;

/**
 * @file git2/rebase.h
 * @brief Git rebase routines
 * @defgroup git_rebase Git merge routines
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

/**
 * Rebase options
 *
 * Use to tell the rebase machinery how to operate.
 */
struct git_rebase_options
{
	uint version_;

	/**
	 * Used by `git_rebase_init`, this will instruct other clients working
	 * on this rebase that you want a quiet rebase experience, which they
	 * may choose to provide in an application-specific manner.  This has no
	 * effect upon libgit2 directly, but is provided for interoperability
	 * between Git tools.
	 */
	int quiet;

	/**
	 * Used by `git_rebase_init`, this will begin an in-memory rebase,
	 * which will allow callers to step through the rebase operations and
	 * commit the rebased changes, but will not rewind HEAD or update the
	 * repository to be in a rebasing state.  This will not interfere with
	 * the working directory (if there is one).
	 */
	int inmemory;

	/**
	 * Used by `git_rebase_finish`, this is the name of the notes reference
	 * used to rewrite notes for rebased commits when finishing the rebase;
	 * if null, the contents of the configuration option `notes.rewriteRef`
	 * is examined, unless the configuration option `notes.rewrite.rebase`
	 * is set to false.  If `notes.rewriteRef` is also null, notes will
	 * not be rewritten.
	 */
	const (char)* rewrite_notes_ref;

	/**
	 * Options to control how trees are merged during `git_rebase_next`.
	 */
	libgit2_d.merge.git_merge_options merge_options;

	/**
	 * Options to control how files are written during `git_rebase_init`,
	 * `git_rebase_next` and `git_rebase_abort`.  Note that a minimum
	 * strategy of `git_checkout_strategy_t.GIT_CHECKOUT_SAFE` is defaulted in `init` and `next`,
	 * and a minimum strategy of `git_checkout_strategy_t.GIT_CHECKOUT_FORCE` is defaulted in
	 * `abort` to match git semantics.
	 */
	libgit2_d.checkout.git_checkout_options checkout_options;

	/**
	 * If provided, this will be called with the commit content, allowing
	 * a signature to be added to the rebase commit. Can be skipped with
	 * git_error_code.GIT_PASSTHROUGH. If git_error_code.GIT_PASSTHROUGH is returned, a commit will be made
	 * without a signature.
	 * This field is only used when performing git_rebase_commit.
	 */
	libgit2_d.commit.git_commit_signing_cb signing_cb;

	/**
	 * This will be passed to each of the callbacks in this struct
	 * as the last parameter.
	 */
	void* payload;
}

/**
 * Type of rebase operation in-progress after calling `git_rebase_next`.
 */
enum git_rebase_operation_t
{
	/**
	 * The given commit is to be cherry-picked.  The client should commit
	 * the changes and continue if there are no conflicts.
	 */
	GIT_REBASE_OPERATION_PICK = 0,

	/**
	 * The given commit is to be cherry-picked, but the client should prompt
	 * the user to provide an updated commit message.
	 */
	GIT_REBASE_OPERATION_REWORD,

	/**
	 * The given commit is to be cherry-picked, but the client should stop
	 * to allow the user to edit the changes before committing them.
	 */
	GIT_REBASE_OPERATION_EDIT,

	/**
	 * The given commit is to be squashed into the previous commit.  The
	 * commit message will be merged with the previous message.
	 */
	GIT_REBASE_OPERATION_SQUASH,

	/**
	 * The given commit is to be squashed into the previous commit.  The
	 * commit message from this commit will be discarded.
	 */
	GIT_REBASE_OPERATION_FIXUP,

	/**
	 * No commit will be cherry-picked.  The client should run the given
	 * command and (if successful) continue.
	 */
	GIT_REBASE_OPERATION_EXEC,
}

//Declaration name in C language
enum
{
	GIT_REBASE_OPERATION_PICK = .git_rebase_operation_t.GIT_REBASE_OPERATION_PICK,
	GIT_REBASE_OPERATION_REWORD = .git_rebase_operation_t.GIT_REBASE_OPERATION_REWORD,
	GIT_REBASE_OPERATION_EDIT = .git_rebase_operation_t.GIT_REBASE_OPERATION_EDIT,
	GIT_REBASE_OPERATION_SQUASH = .git_rebase_operation_t.GIT_REBASE_OPERATION_SQUASH,
	GIT_REBASE_OPERATION_FIXUP = .git_rebase_operation_t.GIT_REBASE_OPERATION_FIXUP,
	GIT_REBASE_OPERATION_EXEC = .git_rebase_operation_t.GIT_REBASE_OPERATION_EXEC,
}

enum GIT_REBASE_OPTIONS_VERSION = 1;

pragma(inline, true)
pure nothrow @safe @nogc
.git_rebase_options GIT_REBASE_OPTIONS_INIT()

	do
	{
		.git_rebase_options OUTPUT =
		{
			version_: .GIT_REBASE_OPTIONS_VERSION,
			quiet: 0,
			inmemory: 0,
			rewrite_notes_ref: null,
			merge_options: libgit2_d.merge.GIT_MERGE_OPTIONS_INIT(),
			checkout_options: libgit2_d.checkout.GIT_CHECKOUT_OPTIONS_INIT(),
			signing_cb: null,
		};

		return OUTPUT;
	}

/**
 * Indicates that a rebase operation is not (yet) in progress.
 */
enum GIT_REBASE_NO_OPERATION = size_t.max;

/**
 * A rebase operation
 *
 * Describes a single instruction/operation to be performed during the
 * rebase.
 */
struct git_rebase_operation
{
	/**
	 * The type of rebase operation.
	 */
	.git_rebase_operation_t type;

	/**
	 * The commit ID being cherry-picked.  This will be populated for
	 * all operations except those of type `git_rebase_operation_t.GIT_REBASE_OPERATION_EXEC`.
	 */
	const libgit2_d.oid.git_oid id;

	/**
	 * The executable the user has requested be run.  This will only
	 * be populated for operations of type `git_rebase_operation_t.GIT_REBASE_OPERATION_EXEC`.
	 */
	const (char)* exec;
}

/**
 * Initialize git_rebase_options structure
 *
 * Initializes a `git_rebase_options` with default values. Equivalent to
 * creating an instance with `GIT_REBASE_OPTIONS_INIT`.
 *
 * Params:
 *      opts = The `git_rebase_options` struct to initialize.
 *      version = The struct version; pass `GIT_REBASE_OPTIONS_VERSION`.
 *
 * Returns: Zero on success; -1 on failure.
 */
//GIT_EXTERN
int git_rebase_options_init(.git_rebase_options* opts, uint version_);

/**
 * Initializes a rebase operation to rebase the changes in `branch`
 * relative to `upstream` onto another branch.  To begin the rebase
 * process, call `git_rebase_next`.  When you have finished with this
 * object, call `git_rebase_free`.
 *
 * Params:
 *      out_ = Pointer to store the rebase object
 *      repo = The repository to perform the rebase
 *      branch = The terminal commit to rebase, or null to rebase the current branch
 *      upstream = The commit to begin rebasing from, or null to rebase all reachable commits
 *      onto = The branch to rebase onto, or null to rebase onto the given upstream
 *      opts = Options to specify how rebase is performed, or null
 *
 * Returns: Zero on success; -1 on failure.
 */
//GIT_EXTERN
int git_rebase_init(libgit2_d.types.git_rebase** out_, libgit2_d.types.git_repository* repo, const (libgit2_d.types.git_annotated_commit)* branch, const (libgit2_d.types.git_annotated_commit)* upstream, const (libgit2_d.types.git_annotated_commit)* onto, const (.git_rebase_options)* opts);

/**
 * Opens an existing rebase that was previously started by either an
 * invocation of `git_rebase_init` or by another client.
 *
 * Params:
 *      out_ = Pointer to store the rebase object
 *      repo = The repository that has a rebase in-progress
 *      opts = Options to specify how rebase is performed
 *
 * Returns: Zero on success; -1 on failure.
 */
//GIT_EXTERN
int git_rebase_open(libgit2_d.types.git_rebase** out_, libgit2_d.types.git_repository* repo, const (git_rebase_options)* opts);

/**
 * Gets the original `HEAD` ref name for merge rebases.
 *
 * Returns: The original `HEAD` ref name
 */
//GIT_EXTERN
const (char)* git_rebase_orig_head_name(libgit2_d.types.git_rebase* rebase);

/**
 * Gets the original `HEAD` id for merge rebases.
 *
 * Returns: The original `HEAD` id
 */
//GIT_EXTERN
const (libgit2_d.oid.git_oid)* git_rebase_orig_head_id(libgit2_d.types.git_rebase* rebase);

/**
 * Gets the `onto` ref name for merge rebases.
 *
 * Returns: The `onto` ref name
 */
//GIT_EXTERN
const (char)* git_rebase_onto_name(libgit2_d.types.git_rebase* rebase);

/**
 * Gets the `onto` id for merge rebases.
 *
 * Returns: The `onto` id
 */
//GIT_EXTERN
const (libgit2_d.oid.git_oid)* git_rebase_onto_id(libgit2_d.types.git_rebase* rebase);

/**
 * Gets the count of rebase operations that are to be applied.
 *
 * Params:
 *      rebase = The in-progress rebase
 *
 * Returns: The number of rebase operations in total
 */
//GIT_EXTERN
size_t git_rebase_operation_entrycount(libgit2_d.types.git_rebase* rebase);

/**
 * Gets the index of the rebase operation that is currently being applied.
 * If the first operation has not yet been applied (because you have
 * called `init` but not yet `next`) then this returns
 * `GIT_REBASE_NO_OPERATION`.
 *
 * Params:
 *      rebase = The in-progress rebase
 *
 * Returns: The index of the rebase operation currently being applied.
 */
//GIT_EXTERN
size_t git_rebase_operation_current(libgit2_d.types.git_rebase* rebase);

/**
 * Gets the rebase operation specified by the given index.
 *
 * Params:
 *      rebase = The in-progress rebase
 *      idx = The index of the rebase operation to retrieve
 *
 * Returns: The rebase operation or null if `idx` was out of bounds
 */
//GIT_EXTERN
.git_rebase_operation* git_rebase_operation_byindex(libgit2_d.types.git_rebase* rebase, size_t idx);

/**
 * Performs the next rebase operation and returns the information about it.
 * If the operation is one that applies a patch (which is any operation except
 * git_rebase_operation_t.GIT_REBASE_OPERATION_EXEC) then the patch will be applied and the index and
 * working directory will be updated with the changes.  If there are conflicts,
 * you will need to address those before committing the changes.
 *
 * Params:
 *      operation = Pointer to store the rebase operation that is to be performed next
 *      rebase = The rebase in progress
 *
 * Returns: Zero on success; -1 on failure.
 */
//GIT_EXTERN
int git_rebase_next(.git_rebase_operation** operation, libgit2_d.types.git_rebase* rebase);

/**
 * Gets the index produced by the last operation, which is the result
 * of `git_rebase_next` and which will be committed by the next
 * invocation of `git_rebase_commit`.  This is useful for resolving
 * conflicts in an in-memory rebase before committing them.  You must
 * call `git_index_free` when you are finished with this.
 *
 * This is only applicable for in-memory rebases; for rebases within
 * a working directory, the changes were applied to the repository's
 * index.
 */
//GIT_EXTERN
int git_rebase_inmemory_index(libgit2_d.types.git_index** index, libgit2_d.types.git_rebase* rebase);

/**
 * Commits the current patch.  You must have resolved any conflicts that
 * were introduced during the patch application from the `git_rebase_next`
 * invocation.
 *
 * Params:
 *      id = Pointer in which to store the OID of the newly created commit
 *      rebase = The rebase that is in-progress
 *      author = The author of the updated commit, or null to keep the author from the original commit
 *      committer = The committer of the rebase
 *      message_encoding = The encoding for the message in the commit, represented with a standard encoding name.  If message is null, this should also be null, and the encoding from the original commit will be maintained.  If message is specified, this may be null to indicate that "UTF-8" is to be used.
 *      message = The message for this commit, or null to use the message from the original commit.
 *
 * Returns: Zero on success, git_error_code.GIT_EUNMERGED if there are unmerged changes in the index, git_error_code.GIT_EAPPLIED if the current commit has already been applied to the upstream and there is nothing to commit, -1 on failure.
 */
//GIT_EXTERN
int git_rebase_commit(libgit2_d.oid.git_oid* id, libgit2_d.types.git_rebase* rebase, const (libgit2_d.types.git_signature)* author, const (libgit2_d.types.git_signature)* committer, const (char)* message_encoding, const (char)* message);

/**
 * Aborts a rebase that is currently in progress, resetting the repository
 * and working directory to their state before rebase began.
 *
 * Params:
 *      rebase = The rebase that is in-progress
 *
 * Returns: Zero on success; git_error_code.GIT_ENOTFOUND if a rebase is not in progress, -1 on other errors.
 */
//GIT_EXTERN
int git_rebase_abort(libgit2_d.types.git_rebase* rebase);

/**
 * Finishes a rebase that is currently in progress once all patches have
 * been applied.
 *
 * Params:
 *      rebase = The rebase that is in-progress
 *      signature = The identity that is finishing the rebase (optional)
 *
 * Returns: Zero on success; -1 on error
 */
//GIT_EXTERN
int git_rebase_finish(libgit2_d.types.git_rebase* rebase, const (libgit2_d.types.git_signature)* signature);

/**
 * Frees the `git_rebase` object.
 *
 * Params:
 *      rebase = The rebase object
 */
//GIT_EXTERN
void git_rebase_free(libgit2_d.types.git_rebase* rebase);

/** @} */
