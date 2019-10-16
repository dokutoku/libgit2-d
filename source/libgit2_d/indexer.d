/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2_d.indexer;


private static import libgit2_d.common;
private static import libgit2_d.oid;
private static import libgit2_d.types;

extern (C):
nothrow @nogc:

struct git_indexer;

/**
 * Create a new indexer instance
 *
 * @param out_ where to store the indexer instance
 * @param path to the directory where the packfile should be stored
 * @param mode permissions to use creating packfile or 0 for defaults
 * @param odb object database from which to read base objects when
 * fixing thin packs. Pass null if no thin pack is expected (an error
 * will be returned if there are bases missing)
 * @param progress_cb function to call with progress information
 * @param progress_cb_payload payload for the progress callback
 */
//GIT_EXTERN
int git_indexer_new(.git_indexer** out_, const (char)* path, uint mode, libgit2_d.types.git_odb* odb, libgit2_d.types.git_transfer_progress_cb progress_cb, void* progress_cb_payload);

/**
 * Add data to the indexer
 *
 * @param idx the indexer
 * @param data the data to add
 * @param size the size of the data in bytes
 * @param stats stat storage
 */
//GIT_EXTERN
int git_indexer_append(.git_indexer* idx, const (void)* data, size_t size, libgit2_d.types.git_transfer_progress* stats);

/**
 * Finalize the pack and index
 *
 * Resolve any pending deltas and write out the index file
 *
 * @param idx the indexer
 */
//GIT_EXTERN
int git_indexer_commit(.git_indexer* idx, libgit2_d.types.git_transfer_progress* stats);

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
