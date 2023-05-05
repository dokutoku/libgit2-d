/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
/**
 * License: GPL-2.0(Linking Exception)
 */
module libgit2.odb_backend;


private static import libgit2.indexer;
private static import libgit2.oid;
private static import libgit2.types;
private import libgit2.common: GIT_EXTERN;

/*
 * @file git2/backend.h
 * @brief Git custom backend functions
 * @defgroup git_odb Git object database routines
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

/*
 * Constructors for in-box ODB backends.
 */

/**
 * Options for configuring a packfile object backend.
 */
struct git_odb_backend_pack_options
{
	/**
	 * version for the struct
	 */
	uint version_;

	/**
	 * Type of object IDs to use for this object database, or
	 * 0 for default (currently SHA1).
	 */
	libgit2.oid.git_oid_t oid_type;
}

/**
 * The current version of the diff options structure
 */
enum GIT_ODB_BACKEND_PACK_OPTIONS_VERSION = 1;

/**
 * Stack initializer for odb pack backend options.  Alternatively use
 * `git_odb_backend_pack_options_init` programmatic initialization.
 */
pragma(inline, true)
pure nothrow @safe @nogc @live
.git_odb_backend_pack_options GIT_ODB_BACKEND_PACK_OPTIONS_INIT()

	do
	{
		.git_odb_backend_pack_options OUTPUT =
		{
			version_: .GIT_ODB_BACKEND_PACK_OPTIONS_VERSION,
		};

		return OUTPUT;
	}

version (GIT_EXPERIMENTAL_SHA256) {
	/**
	 * Create a backend for the packfiles.
	 *
	 * Params:
	 *      out_ = location to store the odb backend pointer
	 *      objects_dir = the Git repository's objects directory
	 *      opts = ?
	 *
	 * Returns: 0 or an error code
	 */
	@GIT_EXTERN
	int git_odb_backend_pack(libgit2.types.git_odb_backend** out_, const (char)* objects_dir, const (.git_odb_backend_pack_options)* opts);
} else {
	/**
	 * Create a backend for the packfiles.
	 *
	 * Params:
	 *      out_ = location to store the odb backend pointer
	 *      objects_dir = the Git repository's objects directory
	 *
	 * Returns: 0 or an error code
	 */
	@GIT_EXTERN
	int git_odb_backend_pack(libgit2.types.git_odb_backend** out_, const (char)* objects_dir);
}

version (GIT_EXPERIMENTAL_SHA256) {
	/**
	 * Create a backend out of a single packfile
	 *
	 * This can be useful for inspecting the contents of a single
	 * packfile.
	 *
	 * @param out_ location to store the odb backend pointer
	 * @param index_file path to the packfile's .idx file
	 *      opts = ?
	 *
	 * @return 0 or an error code
	 */
	@GIT_EXTERN
	int git_odb_backend_one_pack(libgit2.types.git_odb_backend** out_, const (char)* index_file, const (git_odb_backend_pack_options)* opts);
} else {
	/**
	 * Create a backend out of a single packfile
	 *
	 * This can be useful for inspecting the contents of a single
	 * packfile.
	 *
	 * @param out_ location to store the odb backend pointer
	 * @param index_file path to the packfile's .idx file
	 *
	 * @return 0 or an error code
	 */
	@GIT_EXTERN
	int git_odb_backend_one_pack(libgit2.types.git_odb_backend** out_, const (char)* index_file);
}

enum git_odb_backend_loose_flag_t
{
	GIT_ODB_BACKEND_LOOSE_FSYNC = 1 << 0,
}

//Declaration name in C language
enum
{
	GIT_ODB_BACKEND_LOOSE_FSYNC = .git_odb_backend_loose_flag_t.GIT_ODB_BACKEND_LOOSE_FSYNC,
}

/**
 * Options for configuring a loose object backend.
 */
struct git_odb_backend_loose_options
{
	/**
	 * version for the struct
	 */
	uint version_;

	/**
	 * A combination of the `git_odb_backend_loose_flag_t` types.
	 */
	uint flags;

	/**
	 * zlib compression level to use (0-9), where 1 is the fastest
	 * at the expense of larger files, and 9 produces the best
	 * compression at the expense of speed.  0 indicates that no
	 * compression should be performed.  -1 is the default (currently
	 * optimizing for speed).
	 */
	int compression_level;

	/**
	 * Permissions to use creating a directory or 0 for defaults
	 */
	uint dir_mode;

	/**
	 * Permissions to use creating a file or 0 for defaults
	 */
	uint file_mode;

	/**
	 * Type of object IDs to use for this object database, or
	 * 0 for default (currently SHA1).
	 */
	libgit2.oid.git_oid_t oid_type;
}

/**
 * The current version of the diff options structure
 */
enum GIT_ODB_BACKEND_LOOSE_OPTIONS_VERSION = 1;

/**
 * Stack initializer for odb loose backend options.  Alternatively use
 * `git_odb_backend_loose_options_init` programmatic initialization.
 */
pragma(inline, true)
pure nothrow @safe @nogc @live
.git_odb_backend_loose_options GIT_ODB_BACKEND_LOOSE_OPTIONS_INIT()

	do
	{
		.git_odb_backend_loose_options OUTPUT =
		{
			version_: .GIT_ODB_BACKEND_LOOSE_OPTIONS_VERSION,
		};

		return OUTPUT;
	}

version (GIT_EXPERIMENTAL_SHA256) {
	/**
	 * Create a backend for loose objects
	 *
	 * Params:
	 *      out_ = location to store the odb backend pointer
	 *      objects_dir = the Git repository's objects directory
	 *      opts = options for the loose object backend or NULL
	 *
	 * Returns: 0 or an error code
	 */
	@GIT_EXTERN
	int git_odb_backend_loose(libgit2.types.git_odb_backend** out_, const (char)* objects_dir, .git_odb_backend_loose_options* opts);
} else {
	/**
	 * Create a backend for loose objects
	 *
	 * Params:
	 *      out_ = location to store the odb backend pointer
	 *      objects_dir = the Git repository's objects directory
	 *      compression_level = zlib compression level to use
	 *      do_fsync = whether to do an fsync() after writing
	 *      dir_mode = permissions to use creating a directory or 0 for defaults
	 *      file_mode = permissions to use creating a file or 0 for defaults
	 *
	 * Returns: 0 or an error code
	 */
	@GIT_EXTERN
	int git_odb_backend_loose(libgit2.types.git_odb_backend** out_, const (char)* objects_dir, int compression_level, int do_fsync, uint dir_mode, uint file_mode);
}

/**
 * Streaming mode
 */
enum git_odb_stream_t
{
	GIT_STREAM_RDONLY = 1 << 1,
	GIT_STREAM_WRONLY = 1 << 2,
	GIT_STREAM_RW = GIT_STREAM_RDONLY | GIT_STREAM_WRONLY,
}

//Declaration name in C language
enum
{
	GIT_STREAM_RDONLY = .git_odb_stream_t.GIT_STREAM_RDONLY,
	GIT_STREAM_WRONLY = .git_odb_stream_t.GIT_STREAM_WRONLY,
	GIT_STREAM_RW = .git_odb_stream_t.GIT_STREAM_RW,
}

/**
 * A stream to read/write from a backend.
 *
 * This represents a stream of data being written to or read from a
 * backend. When writing, the frontend functions take care of
 * calculating the object's id and all `finalize_write` needs to do is
 * store the object with the id it is passed.
 */
struct git_odb_stream
{
	libgit2.types.git_odb_backend* backend;
	uint mode;
	void* hash_ctx;

	version (GIT_EXPERIMENTAL_SHA256) {
		libgit2.oid.git_oid_t oid_type;
	}

	libgit2.types.git_object_size_t declared_size;
	libgit2.types.git_object_size_t received_bytes;

	/**
	 * Write at most `len` bytes into `buffer` and advance the stream.
	 */
	int function(.git_odb_stream* stream, char* buffer, size_t len) read;

	/**
	 * Write `len` bytes from `buffer` into the stream.
	 */
	int function(.git_odb_stream* stream, const (char)* buffer, size_t len) write;

	/**
	 * Store the contents of the stream as an object with the id
	 * specified in `oid`.
	 *
	 * This method might not be invoked if:
	 * - an error occurs earlier with the `write` callback,
	 * - the object referred to by `oid` already exists in any backend, or
	 * - the final number of received bytes differs from the size declared
	 *   with `git_odb_open_wstream()`
	 */
	int function(.git_odb_stream* stream, const (libgit2.oid.git_oid)* oid) finalize_write;

	/**
	 * Free the stream's memory.
	 *
	 * This method might be called without a call to `finalize_write` if
	 * an error occurs or if the object is already present in the ODB.
	 */
	void function(.git_odb_stream* stream) free;
}

/**
 * A stream to write a pack file to the ODB
 */
struct git_odb_writepack
{
	libgit2.types.git_odb_backend* backend;

	int function(.git_odb_writepack* writepack, const (void)* data, size_t size, libgit2.indexer.git_indexer_progress* stats) append;
	int function(.git_odb_writepack* writepack, libgit2.indexer.git_indexer_progress* stats) commit;
	void function(.git_odb_writepack* writepack) free;
}
