/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
/**
 * License: GPL-2.0(Linking Exception)
 */
module libgit2.blob;


private static import libgit2.buffer;
private static import libgit2.oid;
private static import libgit2.types;
private import libgit2.common: GIT_EXTERN;

/*
 * @file git2/blob.h
 * @brief Git blob load and write routines
 * @defgroup git_blob Git blob load and write routines
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

/**
 * Lookup a blob object from a repository.
 *
 * Params:
 *      blob = pointer to the looked up blob
 *      repo = the repo to use when locating the blob.
 *      id = identity of the blob to locate.
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_blob_lookup(libgit2.types.git_blob** blob, libgit2.types.git_repository* repo, const (libgit2.oid.git_oid)* id);

/**
 * Lookup a blob object from a repository,
 * given a prefix of its identifier (short id).
 *
 * @see git_object_lookup_prefix
 *
 * Params:
 *      blob = pointer to the looked up blob
 *      repo = the repo to use when locating the blob.
 *      id = identity of the blob to locate.
 *      len = the length of the short identifier
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_blob_lookup_prefix(libgit2.types.git_blob** blob, libgit2.types.git_repository* repo, const (libgit2.oid.git_oid)* id, size_t len);

/**
 * Close an open blob
 *
 * This is a wrapper around git_object_free()
 *
 * IMPORTANT:
 * It *is* necessary to call this method when you stop
 * using a blob. Failure to do so will cause a memory leak.
 *
 * Params:
 *      blob = the blob to close
 */
@GIT_EXTERN
void git_blob_free(libgit2.types.git_blob* blob);

/**
 * Get the id of a blob.
 *
 * Params:
 *      blob = a previously loaded blob.
 *
 * Returns: SHA1 hash for this blob.
 */
@GIT_EXTERN
const (libgit2.oid.git_oid)* git_blob_id(const (libgit2.types.git_blob)* blob);

/**
 * Get the repository that contains the blob.
 *
 * Params:
 *      blob = A previously loaded blob.
 *
 * Returns: Repository that contains this blob.
 */
@GIT_EXTERN
libgit2.types.git_repository* git_blob_owner(const (libgit2.types.git_blob)* blob);

/**
 * Get a read-only buffer with the raw content of a blob.
 *
 * A pointer to the raw content of a blob is returned;
 * this pointer is owned internally by the object and shall
 * not be free'd. The pointer may be invalidated at a later
 * time.
 *
 * Params:
 *      blob = pointer to the blob
 *
 * Returns: the pointer, or null on error
 */
@GIT_EXTERN
const (void)* git_blob_rawcontent(const (libgit2.types.git_blob)* blob);

/**
 * Get the size in bytes of the contents of a blob
 *
 * Params:
 *      blob = pointer to the blob
 *
 * Returns: size on bytes
 */
@GIT_EXTERN
libgit2.types.git_object_size_t git_blob_rawsize(const (libgit2.types.git_blob)* blob);

/**
 * Flags to control the functionality of `git_blob_filter`.
 */
enum git_blob_filter_flag_t
{
	/**
	 * When set, filters will not be applied to binary files.
	 */
	GIT_BLOB_FILTER_CHECK_FOR_BINARY = 1 << 0,

	/**
	 * When set, filters will not load configuration from the
	 * system-wide `gitattributes` in `/etc` (or system equivalent).
	 */
	GIT_BLOB_FILTER_NO_SYSTEM_ATTRIBUTES = 1 << 1,

	/**
	 * When set, filters will be loaded from a `.gitattributes` file
	 * in the HEAD commit.
	 */
	GIT_BLOB_FILTER_ATTRIBUTES_FROM_HEAD = 1 << 2,

	/**
	 * When set, filters will be loaded from a `.gitattributes` file
	 * in the specified commit.
	 */
	GIT_BLOB_FILTER_ATTRIBUTES_FROM_COMMIT = 1 << 3,
}

//Declaration name in C language
enum
{
	GIT_BLOB_FILTER_CHECK_FOR_BINARY = .git_blob_filter_flag_t.GIT_BLOB_FILTER_CHECK_FOR_BINARY,
	GIT_BLOB_FILTER_NO_SYSTEM_ATTRIBUTES = .git_blob_filter_flag_t.GIT_BLOB_FILTER_NO_SYSTEM_ATTRIBUTES,
	GIT_BLOB_FILTER_ATTRIBUTES_FROM_HEAD = .git_blob_filter_flag_t.GIT_BLOB_FILTER_ATTRIBUTES_FROM_HEAD,
	GIT_BLOB_FILTER_ATTRIBUTES_FROM_COMMIT = .git_blob_filter_flag_t.GIT_BLOB_FILTER_ATTRIBUTES_FROM_COMMIT,
}

/**
 * The options used when applying filter options to a file.
 *
 * Initialize with `GIT_BLOB_FILTER_OPTIONS_INIT`. Alternatively, you can
 * use `git_blob_filter_options_init`.
 */
struct git_blob_filter_options
{
	int version_;

	/**
	 * Flags to control the filtering process, see `git_blob_filter_flag_t` above
	 */
	uint flags;

	/**
	 * The commit to load attributes from, when
	 * `GIT_BLOB_FILTER_ATTRIBUTES_FROM_COMMIT` is specified.
	 */
	libgit2.oid.git_oid* commit_id;
}

enum GIT_BLOB_FILTER_OPTIONS_VERSION = 1;

pragma(inline, true)
pure nothrow @safe @nogc @live
.git_blob_filter_options GIT_BLOB_FILTER_OPTIONS_INIT()

	do
	{
		.git_blob_filter_options OUTPUT =
		{
			version_: .GIT_BLOB_FILTER_OPTIONS_VERSION,
			flags: .git_blob_filter_flag_t.GIT_BLOB_FILTER_CHECK_FOR_BINARY,
		};

		return OUTPUT;
	}

/**
 * Initialize git_blob_filter_options structure
 *
 * Initializes a `git_blob_filter_options` with default values. Equivalent
 * to creating an instance with `GIT_BLOB_FILTER_OPTIONS_INIT`.
 *
 * Params:
 *      opts = The `git_blob_filter_options` struct to initialize.
 *      version_ = The struct version; pass `GIT_BLOB_FILTER_OPTIONS_VERSION`.
 *
 * Returns: Zero on success; -1 on failure.
 */
@GIT_EXTERN
int git_blob_filter_options_init(.git_blob_filter_options* opts, uint version_);

/**
 * Get a buffer with the filtered content of a blob.
 *
 * This applies filters as if the blob was being checked out to the
 * working directory under the specified filename.  This may apply
 * CRLF filtering or other types of changes depending on the file
 * attributes set for the blob and the content detected in it.
 *
 * The output is written into a `git_buf` which the caller must free
 * when done (via `git_buf_dispose`).
 *
 * If no filters need to be applied, then the `out` buffer will just
 * be populated with a pointer to the raw content of the blob.  In
 * that case, be careful to *not* free the blob until done with the
 * buffer or copy it into memory you own.
 *
 * Params:
 *      out_ = The git_buf to be filled in
 *      blob = Pointer to the blob
 *      as_path = Path used for file attribute lookups, etc.
 *      opts = Options to use for filtering the blob
 *
 * Returns: 0 on success or an error code
 */
@GIT_EXTERN
int git_blob_filter(libgit2.buffer.git_buf* out_, libgit2.types.git_blob* blob, const (char)* as_path, .git_blob_filter_options* opts);

/**
 * Read a file from the working folder of a repository
 * and write it to the Object Database as a loose blob
 *
 * Params:
 *      id = return the id of the written blob
 *      repo = repository where the blob will be written. this repository cannot be bare
 *      relative_path = file from which the blob will be created, relative to the repository's working dir
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_blob_create_from_workdir(libgit2.oid.git_oid* id, libgit2.types.git_repository* repo, const (char)* relative_path);

/**
 * Read a file from the filesystem and write its content
 * to the Object Database as a loose blob
 *
 * Params:
 *      id = return the id of the written blob
 *      repo = repository where the blob will be written. this repository can be bare or not
 *      path = file from which the blob will be created
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_blob_create_from_disk(libgit2.oid.git_oid* id, libgit2.types.git_repository* repo, const (char)* path);

/**
 * Create a stream to write a new blob into the object db
 *
 * This function may need to buffer the data on disk and will in
 * general not be the right choice if you know the size of the data
 * to write. If you have data in memory, use
 * `git_blob_create_from_buffer()`. If you do not, but know the size of
 * the contents (and don't want/need to perform filtering), use
 * `git_odb_open_wstream()`.
 *
 * Don't close this stream yourself but pass it to
 * `git_blob_create_from_stream_commit()` to commit the write to the
 * object db and get the object id.
 *
 * If the `hintpath` parameter is filled, it will be used to determine
 * what git filters should be applied to the object before it is written
 * to the object database.
 *
 * Params:
 *      out_ = the stream into which to write
 *      repo = Repository where the blob will be written. This repository can be bare or not.
 *      hintpath = If not null, will be used to select data filters to apply onto the content of the blob to be created.
 *
 * Returns: 0 or error code
 */
@GIT_EXTERN
int git_blob_create_from_stream(libgit2.types.git_writestream** out_, libgit2.types.git_repository* repo, const (char)* hintpath);

/**
 * Close the stream and write the blob to the object db
 *
 * The stream will be closed and freed.
 *
 * Params:
 *      out_ = the id of the new blob
 *      stream = the stream to close
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_blob_create_from_stream_commit(libgit2.oid.git_oid* out_, libgit2.types.git_writestream* stream);

/**
 * Write an in-memory buffer to the ODB as a blob
 *
 * Params:
 *      id = return the id of the written blob
 *      repo = repository where the blob will be written
 *      buffer = data to be written into the blob
 *      len = length of the data
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_blob_create_from_buffer(libgit2.oid.git_oid* id, libgit2.types.git_repository* repo, const (void)* buffer, size_t len);

/**
 * Determine if the blob content is most certainly binary or not.
 *
 * The heuristic used to guess if a file is binary is taken from core git:
 * Searching for null bytes and looking for a reasonable ratio of printable
 * to non-printable characters among the first 8000 bytes.
 *
 * Params:
 *      blob = The blob which content should be analyzed
 *
 * Returns: 1 if the content of the blob is detected as binary; 0 otherwise.
 */
@GIT_EXTERN
int git_blob_is_binary(const (libgit2.types.git_blob)* blob);

/**
 * Create an in-memory copy of a blob. The copy must be explicitly
 * free'd or it will leak.
 *
 * Params:
 *      out_ = Pointer to store the copy of the object
 *      source = Original object to copy
 */
@GIT_EXTERN
int git_blob_dup(libgit2.types.git_blob** out_, libgit2.types.git_blob* source);

/* @} */
