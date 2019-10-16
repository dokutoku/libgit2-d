/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2_d.sys.odb_backend;


private static import libgit2_d.common;
private static import libgit2_d.odb;
private static import libgit2_d.oid;
private static import libgit2_d.types;

/**
 * @file git2/sys/backend.h
 * @brief Git custom backend implementors functions
 * @defgroup git_backend Git custom backend APIs
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:

/**
 * An instance for a custom backend
 */
struct git_odb_backend
{
	uint version_;
	libgit2_d.types.git_odb* odb;

	/*
	 * read and read_prefix each return to libgit2 a buffer which
	 * will be freed later. The buffer should be allocated using
	 * the function git_odb_backend_malloc to ensure that it can
	 * be safely freed later.
	 */
	int function(void**, size_t*, libgit2_d.types.git_otype*, .git_odb_backend*, const (libgit2_d.oid.git_oid)*) read;

	/*
	 * To find a unique object given a prefix of its oid.  The oid given
	 * must be so that the remaining (GIT_OID_HEXSZ - len)*4 bits are 0s.
	 */
	int function(libgit2_d.oid.git_oid*, void**, size_t*, libgit2_d.types.git_otype*, .git_odb_backend*, const (libgit2_d.oid.git_oid)*, size_t) read_prefix;

	int function(size_t*, libgit2_d.types.git_otype*, .git_odb_backend*, const (libgit2_d.oid.git_oid)*) read_header;

	/**
	 * Write an object into the backend. The id of the object has
	 * already been calculated and is passed in.
	 */
	int function(.git_odb_backend*, const (libgit2_d.oid.git_oid)*, const (void)*, size_t, libgit2_d.types.git_otype) write;

	int function(libgit2_d.odb_backend.git_odb_stream**, .git_odb_backend*, libgit2_d.types.git_off_t, libgit2_d.types.git_otype) writestream;

	int function(libgit2_d.odb_backend.git_odb_stream**, size_t*, libgit2_d.types.git_otype*, .git_odb_backend*, const (libgit2_d.oid.git_oid)*) readstream;

	int function(.git_odb_backend*, const (libgit2_d.oid.git_oid)*) exists;

	int function(libgit2_d.oid.git_oid*, .git_odb_backend*, const (libgit2_d.oid.git_oid)*, size_t) exists_prefix;

	/**
	 * If the backend implements a refreshing mechanism, it should be exposed
	 * through this endpoint. Each call to `git_odb_refresh()` will invoke it.
	 *
	 * However, the backend implementation should try to stay up-to-date as much
	 * as possible by itself as libgit2 will not automatically invoke
	 * `git_odb_refresh()`. For instance, a potential strategy for the backend
	 * implementation to achieve this could be to internally invoke this
	 * endpoint on failed lookups (ie. `exists()`, `read()`, `read_header()`).
	 */
	int function(.git_odb_backend*) refresh;

	int function(.git_odb_backend*, libgit2_d.odb.git_odb_foreach_cb cb, void* payload) foreach_;

	int function(libgit2_d.odb_backend.git_odb_writepack**, .git_odb_backend*, libgit2_d.types.git_odb* odb, libgit2_d.types.git_transfer_progress_cb progress_cb, void* progress_payload) writepack;

	/**
	 * "Freshens" an already existing object, updating its last-used
	 * time.  This occurs when `git_odb_write` was called, but the
	 * object already existed (and will not be re-written).  The
	 * underlying implementation may want to update last-used timestamps.
	 *
	 * If callers implement this, they should return `0` if the object
	 * exists and was freshened, and non-zero otherwise.
	 */
	int function(.git_odb_backend*, const (libgit2_d.oid.git_oid)*) freshen;

	/**
	 * Frees any resources held by the odb (including the `git_odb_backend`
	 * itself). An odb backend implementation must provide this function.
	 */
	void function(.git_odb_backend*) free;
}

enum GIT_ODB_BACKEND_VERSION = 1;

pragma(inline, true)
pure nothrow @safe @nogc
.git_odb_backend GIT_ODB_BACKEND_INIT()

	do
	{
		.git_odb_backend OUTPUT =
		{
			version_: .GIT_ODB_BACKEND_VERSION,
		};

		return OUTPUT;
	}

/**
 * Initializes a `git_odb_backend` with default values. Equivalent to
 * creating an instance with GIT_ODB_BACKEND_INIT.
 *
 * @param backend the `git_odb_backend` struct to initialize.
 * @param version Version the struct; pass `GIT_ODB_BACKEND_VERSION`
 * @return Zero on success; -1 on failure.
 */
//GIT_EXTERN
int git_odb_init_backend(.git_odb_backend* backend, uint version_);

//GIT_EXTERN
void* git_odb_backend_malloc(.git_odb_backend* backend, size_t len);
