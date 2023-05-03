/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
/**
 * License: GPL-2.0(Linking Exception)
 */
module libgit2.sys.refdb_backend;


private static import libgit2.oid;
private static import libgit2.types;
private import libgit2.common: GIT_EXTERN;

/*
 * @file git2/refdb_backend.h
 * @brief Git custom refs backend functions
 * @defgroup git_refdb_backend Git custom refs backend API
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:

/**
 * Every backend's iterator must have a pointer to itself as the first
 * element, so the API can talk to it. You'd define your iterator as
 *
 *     struct my_iterator {
 *             git_reference_iterator parent;
 *             ...
 *     }
 *
 * and assign `iter->parent.backend` to your `git_refdb_backend`.
 */
struct git_reference_iterator
{
	libgit2.types.git_refdb* db;

	/**
	 * Return the current reference and advance the iterator.
	 */
	int function(libgit2.types.git_reference** ref_, .git_reference_iterator* iter) next;

	/**
	 * Return the name of the current reference and advance the iterator
	 */
	int function(const (char)** ref_name, .git_reference_iterator* iter) next_name;

	/**
	 * Free the iterator
	 */
	void function(.git_reference_iterator* iter) free;
}

/**
 * An instance for a custom backend
 */
struct git_refdb_backend
{
	/**
	 * The backend API version
	 */
	uint version_;

	/**
	 * Queries the refdb backend for the existence of a reference.
	 *
	 * A refdb implementation must provide this function.
	 *
	 * Returns: `0` on success, a negative error value code.
	 */
	/*
	 * Params:
	 *      exists = The implementation shall set this to `0` if a ref does not exist, otherwise to `1`.
	 *      backend = ?
	 *      ref_name = The reference's name that should be checked for existence.
	 */
	int function(int* exists, .git_refdb_backend* backend, const (char)* ref_name) exists;

	/**
	 * Queries the refdb backend for a given reference.
	 *
	 * A refdb implementation must provide this function.
	 *
	 * Returns: `0` on success, `GIT_ENOTFOUND` if the reference does exist, otherwise a negative error code.
	 */
	/*
	 * Params:
	 *      out_ = The implementation shall set this to the allocated reference, if it could be found, otherwise to `null`.
	 *      backend = ?
	 *      ref_name = The reference's name that should be checked for existence.
	 */
	int function(libgit2.types.git_reference** out_, .git_refdb_backend* backend, const (char)* ref_name) lookup;

	/**
	 * Allocate an iterator object for the backend.
	 *
	 * A refdb implementation must provide this function.
	 *
	 * Returns: `0` on success, otherwise a negative error code.
	 */
	/*
	 * Params:
	 *      iter = The implementation shall set this to the allocated reference iterator. A custom structure may be used with an embedded `git_reference_iterator` structure. Both `next` and `next_name` functions of `git_reference_iterator` need to be populated.
	 *      backend = ?
	 *      glob = A pattern to filter references by. If given, the iterator shall only return references that match the glob when passed to `wildmatch`.
	 */
	int function(.git_reference_iterator** iter,  .git_refdb_backend* backend, const (char)* glob) iterator;

	/**
	 * Writes the given reference to the refdb.
	 *
	 * A refdb implementation must provide this function.
	 *
	 * Returns: `0` on success, otherwise a negative error code.
	 */
	/*
	 * Params:
	 *      backend = ?
	 *      ref_ = The reference to persist. May either be a symbolic or direct reference.
	 *      force = Whether to write the reference if a reference with the same name already exists.
	 *      who = The person updating the reference. Shall be used to create a reflog entry.
	 *      message = The message detailing what kind of reference update is performed. Shall be used to create a reflog entry.
	 *      old = If not `null` and `force` is not set, then the implementation needs to ensure that the reference is currently at the given OID before writing the new value. If both `old` and `old_target` are `null`, then the reference should not exist at the point of writing.
	 *      old_target = If not `null` and `force` is not set, then the implementation needs to ensure that the symbolic reference is currently at the given target before writing the new value. If both `old` and `old_target` are `null`, then the reference should not exist at the point of writing.
	 */
	int function(.git_refdb_backend* backend, const (libgit2.types.git_reference)* ref_, int force, const (libgit2.types.git_signature)* who, const (char)* message, const (libgit2.oid.git_oid)* old, const (char)* old_target) write;

	/**
	 * Rename a reference in the refdb.
	 *
	 * A refdb implementation must provide this function.
	 *
	 * Returns: `0` on success, otherwise a negative error code.
	 */
	/*
	 * Params:
	 *      out_ = The implementation shall set this to the newly created reference or `null` on error.
	 *      backend = ?
	 *      old_name = The current name of the reference that is to be renamed.
	 *      new_name = The new name that the old reference shall be renamed to.
	 *      force = Whether to write the reference if a reference with the target name already exists.
	 *      who = The person updating the reference. Shall be used to create a reflog entry.
	 *      message = The message detailing what kind of reference update is performed. Shall be used to create a reflog entry.
	 */
	int function(libgit2.types.git_reference** out_, .git_refdb_backend* backend, const (char)* old_name, const (char)* new_name, int force, const (libgit2.types.git_signature)* who, const (char)* message) rename;

	/**
	 * Deletes the given reference from the refdb.
	 *
	 * If it exists, its reflog should be deleted as well.
	 *
	 * A refdb implementation must provide this function.
	 *
	 * Returns: `0` on success, otherwise a negative error code.
	 */
	/*
	 * Params:
	 *      backend = ?
	 *      ref_name = The name of the reference name that shall be deleted.
	 *      old_id = If not `null` and `force` is not set, then the implementation needs to ensure that the reference is currently at the given OID before writing the new value.
	 *      old_target = If not `null` and `force` is not set, then the implementation needs to ensure that the symbolic reference is currently at the given target before writing the new value.
	 */
	int function(.git_refdb_backend* backend, const (char)* ref_name, const (libgit2.oid.git_oid)* old_id, const (char)* old_target) del;

	/**
	 * Suggests that the given refdb compress or optimize its references.
	 *
	 * This mechanism is implementation specific. For on-disk reference
	 * databases, this may pack all loose references.
	 *
	 * A refdb implementation may provide this function; if it is not
	 * provided, nothing will be done.
	 *
	 * Returns: `0` on success a negative error code otherwise
	 */
	int function(.git_refdb_backend* backend) compress;

	/**
	 * Query whether a particular reference has a log (may be empty)
	 *
	 * Shall return 1 if it has a reflog, 0 it it doesn't and negative in
	 * case an error occurred.
	 *
	 * A refdb implementation must provide this function.
	 *
	 * Returns: `0` on success, `1` if the reflog for the given reference exists, a negative error code otherwise
	 */
	int function(.git_refdb_backend* backend, const (char)* refname) has_log;

	/**
	 * Make sure a particular reference will have a reflog which
	 * will be appended to on writes.
	 *
	 * A refdb implementation must provide this function.
	 *
	 * Returns: `0` on success, a negative error code otherwise
	 */
	int function(.git_refdb_backend* backend, const (char)* refname) ensure_log;

	/**
	 * Frees any resources held by the refdb (including the `git_refdb_backend`
	 * itself).
	 *
	 * A refdb backend implementation must provide this function.
	 */
	void function(.git_refdb_backend* backend) free;

	/**
	 * Read the reflog for the given reference name.
	 *
	 * A refdb implementation must provide this function.
	 *
	 * Returns: `0` on success, a negative error code otherwise
	 */
	int function(libgit2.types.git_reflog** out_, .git_refdb_backend* backend, const (char)* name) reflog_read;

	/**
	 * Write a reflog to disk.
	 *
	 * A refdb implementation must provide this function.
	 *
	 * Returns: `0` on success, a negative error code otherwise
	 */
	/*
	 * Params:
	 *      backend = ?
	 *      reflog = The complete reference log for a given reference. Note that this may contain entries that have already been written to disk.
	 */
	int function(.git_refdb_backend* backend, libgit2.types.git_reflog* reflog) reflog_write;

	/**
	 * Rename a reflog.
	 *
	 * A refdb implementation must provide this function.
	 *
	 * Returns: `0` on success, a negative error code otherwise
	 */
	/*
	 * Params:
	 *      backend = ?
	 *      old_name = The name of old reference whose reflog shall be renamed from.
	 *      new_name = The name of new reference whose reflog shall be renamed to.
	 */
	int function(.git_refdb_backend* _backend, const (char)* old_name, const (char)* new_name) reflog_rename;

	/**
	 * Remove a reflog.
	 *
	 * A refdb implementation must provide this function.
	 *
	 * Returns: `0` on success, a negative error code otherwise
	 */
	/*
	 * Params:
	 *      backend = ?
	 *      name = The name of the reference whose reflog shall be deleted.
	 */
	int function(.git_refdb_backend* backend, const (char)* name) reflog_delete;

	/**
	 * Lock a reference.
	 *
	 * A refdb implementation may provide this function; if it is not
	 * provided, the transaction API will fail to work.
	 *
	 * Returns: `0` on success, a negative error code otherwise
	 */
	/*
	 * Params:
	 *      payload_out = Opaque parameter that will be passed verbosely to `unlock`.
	 *      backend = ?
	 *      refname = Reference that shall be locked.
	 */
	int function(void** payload_out, .git_refdb_backend* backend, const (char)* refname) lock;

	/**
	 * Unlock a reference.
	 *
	 * Only one of target or symbolic_target will be set.
	 * `success` will be true if the reference should be update, false if
	 * the lock must be discarded.
	 *
	 * A refdb implementation must provide this function if a `lock`
	 * implementation is provided.
	 *
	 * Returns: `0` on success, a negative error code otherwise
	 */
	/*
	 * Params:
	 *      backend = ?
	 *      payload = The payload returned by `lock`.
	 *      success = `1` if a reference should be updated, `2` if a reference should be deleted, `0` if the lock must be discarded.
	 *      update_reflog = `1` in case the reflog should be updated, `0` otherwise.
	 *      ref_ = The reference which should be unlocked.
	 *      who = The person updating the reference. Shall be used to create a reflog entry in case `update_reflog` is set.
	 *      message = The message detailing what kind of reference update is performed. Shall be used to create a reflog entry in case `update_reflog` is set.
	 */
	int function(.git_refdb_backend* backend, void* payload, int success, int update_reflog, const (libgit2.types.git_reference)* ref_, const (libgit2.types.git_signature)* sig, const (char)* message) unlock;
}

enum GIT_REFDB_BACKEND_VERSION = 1;

pragma(inline, true)
pure nothrow @safe @nogc @live
.git_refdb_backend GIT_REFDB_BACKEND_INIT()

	do
	{
		.git_refdb_backend OUTPUT =
		{
			version_: .GIT_REFDB_BACKEND_VERSION,
		};

		return OUTPUT;
	}

/**
 * Initializes a `git_refdb_backend` with default values. Equivalent to
 * creating an instance with GIT_REFDB_BACKEND_INIT.
 *
 * Params:
 *      backend = the `git_refdb_backend` struct to initialize
 *      version_ = Version of struct; pass `GIT_REFDB_BACKEND_VERSION`
 *
 * Returns: Zero on success; -1 on failure.
 */
@GIT_EXTERN
int git_refdb_init_backend(.git_refdb_backend* backend, uint version_);

/**
 * Constructors for default filesystem-based refdb backend
 *
 * Under normal usage, this is called for you when the repository is
 * opened / created, but you can use this to explicitly construct a
 * filesystem refdb backend for a repository.
 *
 * Params:
 *      backend_out = Output pointer to the git_refdb_backend object
 *      repo = Git repository to access
 *
 * Returns: 0 on success, <0 error code on failure
 */
@GIT_EXTERN
int git_refdb_backend_fs(.git_refdb_backend** backend_out, libgit2.types.git_repository* repo);

/**
 * Sets the custom backend to an existing reference DB
 *
 * The `git_refdb` will take ownership of the `git_refdb_backend` so you
 * should NOT free it after calling this function.
 *
 * Params:
 *      refdb = database to add the backend to
 *      backend = pointer to a git_refdb_backend instance
 *
 * Returns: 0 on success; error code otherwise
 */
@GIT_EXTERN
int git_refdb_set_backend(libgit2.types.git_refdb* refdb, .git_refdb_backend* backend);
