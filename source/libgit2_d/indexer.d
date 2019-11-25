/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2_d.indexer;


private static import libgit2_d.oid;
private static import libgit2_d.types;

extern (C):
nothrow @nogc:
public:

/**
 * A git indexer object
 */
struct git_indexer;

/**
 * This structure is used to provide callers information about the
 * progress of indexing a packfile, either directly or part of a
 * fetch or clone that downloads a packfile.
 */
struct git_indexer_progress
{
	/**
	 * number of objects in the packfile being indexed
	 */
	uint total_objects;

	/**
	 * received objects that have been hashed
	 */
	uint indexed_objects;

	/**
	 * received_objects: objects which have been downloaded
	 */
	uint received_objects;

	/**
	 * locally-available objects that have been injected in order
	 * to fix a thin pack
	 */
	uint local_objects;

	/**
	 * number of deltas in the packfile being indexed
	 */
	uint total_deltas;

	/**
	 * received deltas that have been indexed
	 */
	uint indexed_deltas;

	/**
	 * size of the packfile received up to now
	 */
	size_t received_bytes;
}

/**
 * Type for progress callbacks during indexing.  Return a value less
 * than zero to cancel the indexing or download.
 *
 * @param stats Structure containing information about the state of the tran    sfer
 * @param payload Payload provided by caller
 */
alias git_indexer_progress_cb = int function(const (.git_indexer_progress)* stats, void* payload);

/**
 * Options for indexer configuration
 */
struct git_indexer_options
{
	uint version_;

	/**
	 * progress_cb function to call with progress information
	 */
	.git_indexer_progress_cb progress_cb;

	/**
	 * progress_cb_payload payload for the progress callback
	 */
	void* progress_cb_payload;

	/**
	 * Do connectivity checks for the received pack
	 */
	ubyte verify;
}

enum GIT_INDEXER_OPTIONS_VERSION = 1;

pragma(inline, true)
pure nothrow @safe @nogc
.git_indexer_options GIT_INDEXER_OPTIONS_INIT()

	do
	{
		.git_indexer_options OUTPUT =
		{
			version_: .GIT_INDEXER_OPTIONS_VERSION,
		};

		return OUTPUT;
	}

/**
 * Initializes a `git_indexer_options` with default values. Equivalent to
 * creating an instance with GIT_INDEXER_OPTIONS_INIT.
 *
 * @param opts the `git_indexer_options` struct to initialize.
 * @param version Version of struct; pass `GIT_INDEXER_OPTIONS_VERSION`
 * @return Zero on success; -1 on failure.
 */
//GIT_EXTERN
int git_indexer_options_init(.git_indexer_options* opts, uint version_);

/**
 * Create a new indexer instance
 *
 * @param out_ where to store the indexer instance
 * @param path to the directory where the packfile should be stored
 * @param mode permissions to use creating packfile or 0 for defaults
 * @param odb object database from which to read base objects when
 * fixing thin packs. Pass null if no thin pack is expected (an error
 * will be returned if there are bases missing)
 * @param opts Optional structure containing additional options. See
 * `git_indexer_options` above.
 */
//GIT_EXTERN
int git_indexer_new(.git_indexer** out_, const (char)* path, uint mode, libgit2_d.types.git_odb* odb, .git_indexer_options* opts);

/**
 * Add data to the indexer
 *
 * @param idx the indexer
 * @param data the data to add
 * @param size the size of the data in bytes
 * @param stats stat storage
 */
//GIT_EXTERN
int git_indexer_append(.git_indexer* idx, const (void)* data, size_t size, .git_indexer_progress* stats);

/**
 * Finalize the pack and index
 *
 * Resolve any pending deltas and write out the index file
 *
 * @param idx the indexer
 */
//GIT_EXTERN
int git_indexer_commit(.git_indexer* idx, .git_indexer_progress* stats);

/**
 * Get the packfile's hash
 *
 * A packfile's name is derived from the sorted hashing of all object
 * names. This is only correct after the index has been finalized.
 *
 * @param idx the indexer instance
 */
//GIT_EXTERN
const (libgit2_d.oid.git_oid)* git_indexer_hash(const (.git_indexer)* idx);

/**
 * Free the indexer and its resources
 *
 * @param idx the indexer to free
 */
//GIT_EXTERN
void git_indexer_free(.git_indexer* idx);
