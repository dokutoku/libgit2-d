/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2_d.sys.refdb_backend;


private static import libgit2_d.common;
private static import libgit2_d.oid;
private static import libgit2_d.types;

/**
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
	libgit2_d.types.git_refdb* db;

	/**
	 * Return the current reference and advance the iterator.
	 */
	int function(libgit2_d.types.git_reference** ref_, .git_reference_iterator* iter) next;

	/**
	 * Return the name of the current reference and advance the iterator
	 */
	int function(const (char)** ref_name, .git_reference_iterator* iter) next_name;

	/**
	 * Free the iterator
	 */
	void function(.git_reference_iterator* iter) free;
}

/** An instance for a custom backend */
struct git_refdb_backend
{
	uint version_;

	/**
	 * Queries the refdb backend to determine if the given ref_name
	 * exists.  A refdb implementation must provide this function.
	 */
	int function(int* exists, .git_refdb_backend* backend, const (char)* ref_name) exists;

	/**
	 * Queries the refdb backend for a given reference.  A refdb
	 * implementation must provide this function.
	 */
	int function(libgit2_d.types.git_reference** out_, .git_refdb_backend* backend, const (char)* ref_name) lookup;

	/**
	 * Allocate an iterator object for the backend.
	 *
	 * A refdb implementation must provide this function.
	 */
	int function(.git_reference_iterator** iter,  .git_refdb_backend* backend, const (char)* glob) iterator;

	/*
	 * Writes the given reference to the refdb.  A refdb implementation
	 * must provide this function.
	 */
	int function(.git_refdb_backend* backend, const (libgit2_d.types.git_reference)* ref_, int force, const (libgit2_d.types.git_signature)* who, const (char)* message, const (libgit2_d.oid.git_oid)* old, const (char)* old_target) write;

	int function(libgit2_d.types.git_reference** out_, .git_refdb_backend* backend, const (char)* old_name, const (char)* new_name, int force, const (libgit2_d.types.git_signature)* who, const (char)* message) rename;

	/**
	 * Deletes the given reference (and if necessary its reflog)
	 * from the refdb.  A refdb implementation must provide this
	 * function.
	 */
	int function(.git_refdb_backend* backend, const (char)* ref_name, const (libgit2_d.oid.git_oid)* old_id, const (char)* old_target) del;

	/**
	 * Suggests that the given refdb compress or optimize its references.
	 * This mechanism is implementation specific.  (For on-disk reference
	 * databases, this may pack all loose references.)    A refdb
	 * implementation may provide this function; if it is not provided,
	 * nothing will be done.
	 */
	int function(.git_refdb_backend* backend) compress;

	/**
	 * Query whether a particular reference has a log (may be empty)
	 */
	int function(.git_refdb_backend* backend, const (char)* refname) has_log;

	/**
	 * Make sure a particular reference will have a reflog which
	 * will be appended to on writes.
	 */
	int function(.git_refdb_backend* backend, const (char)* refname) ensure_log;

	/**
	 * Frees any resources held by the refdb (including the `git_refdb_backend`
	 * itself). A refdb backend implementation must provide this function.
	 */
	void function(.git_refdb_backend* backend) free;

	/**
	 * Read the reflog for the given reference name.
	 */
	int function(libgit2_d.types.git_reflog** out_, .git_refdb_backend* backend, const (char)* name) reflog_read;

	/**
	 * Write a reflog to disk.
	 */
	int function(.git_refdb_backend* backend, libgit2_d.types.git_reflog* reflog) reflog_write;

	/**
	 * Rename a reflog
	 */
	int function(.git_refdb_backend* _backend, const (char)* old_name, const (char)* new_name) reflog_rename;

	/**
	 * Remove a reflog.
	 */
	int function(.git_refdb_backend* backend, const (char)* name) reflog_delete;

	/**
	 * Lock a reference. The opaque parameter will be passed to the unlock
	 * function
	 */
	int function(void** payload_out, .git_refdb_backend* backend, const (char)* refname) lock;

	/**
	 * Unlock a reference. Only one of target or symbolic_target
	 * will be set. success indicates whether to update the
	 * reference or discard the lock (if it's false)
	 */
	int function(.git_refdb_backend* backend, void* payload, int success, int update_reflog, const (libgit2_d.types.git_reference)* ref_, const (libgit2_d.types.git_signature)* sig, const (char)* message) unlock;
}

enum GIT_REFDB_BACKEND_VERSION = 1;

pragma(inline, true)
pure nothrow @safe @nogc
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
 * @param backend the `git_refdb_backend` struct to initialize
 * @param version Version of struct; pass `GIT_REFDB_BACKEND_VERSION`
 * @return Zero on success; -1 on failure.
 */
//GIT_EXTERN
int git_refdb_init_backend(.git_refdb_backend* backend, uint version_);

/**
 * Constructors for default filesystem-based refdb backend
 *
 * Under normal usage, this is called for you when the repository is
 * opened / created, but you can use this to explicitly construct a
 * filesystem refdb backend for a repository.
 *
 * @param backend_out Output pointer to the git_refdb_backend object
 * @param repo Git repository to access
 * @return 0 on success, <0 error code on failure
 */
//GIT_EXTERN
int git_refdb_backend_fs(.git_refdb_backend** backend_out, libgit2_d.types.git_repository* repo);

/**
 * Sets the custom backend to an existing reference DB
 *
 * The `git_refdb` will take ownership of the `git_refdb_backend` so you
 * should NOT free it after calling this function.
 *
 * @param refdb database to add the backend to
 * @param backend pointer to a git_refdb_backend instance
 * @return 0 on success; error code otherwise
 */
//GIT_EXTERN
int git_refdb_set_backend(libgit2_d.types.git_refdb* refdb, .git_refdb_backend* backend);
