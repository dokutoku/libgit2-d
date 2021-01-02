/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2_d.pack;


private static import libgit2_d.buffer;
private static import libgit2_d.indexer;
private static import libgit2_d.oid;
private static import libgit2_d.types;

/**
 * @file git2/pack.h
 * @brief Git pack management routines
 *
 * Packing objects
 * ---------------
 *
 * Creation of packfiles requires two steps:
 *
 * - First, insert all the objects you want to put into the packfile
 *   using `git_packbuilder_insert` and `git_packbuilder_insert_tree`.
 *   It's important to add the objects in recency order ("in the order
 *   that they are 'reachable' from head").
 *
 *   "ANY order will give you a working pack, ... [but it is] the thing
 *   that gives packs good locality. It keeps the objects close to the
 *   head (whether they are old or new, but they are _reachable_ from the
 *   head) at the head of the pack. So packs actually have absolutely
 *   _wonderful_ IO patterns." - Linus Torvalds
 *   git.git/Documentation/technical/pack-heuristics.txt
 *
 * - Second, use `git_packbuilder_write` or `git_packbuilder_foreach` to
 *   write the resulting packfile.
 *
 *   libgit2 will take care of the delta ordering and generation.
 *   `git_packbuilder_set_threads` can be used to adjust the number of
 *   threads used for the process.
 *
 * See tests/pack/packbuilder.c for an example.
 *
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

/**
 * Stages that are reported by the packbuilder progress callback.
 */
enum git_packbuilder_stage_t
{
	GIT_PACKBUILDER_ADDING_OBJECTS = 0,
	GIT_PACKBUILDER_DELTAFICATION = 1,
}

/**
 * Initialize a new packbuilder
 *
 * Params:
 *      out_ = The new packbuilder object
 *      repo = The repository
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_packbuilder_new(libgit2_d.types.git_packbuilder** out_, libgit2_d.types.git_repository* repo);

/**
 * Set number of threads to spawn
 *
 * By default, libgit2 won't spawn any threads at all;
 * when set to 0, libgit2 will autodetect the number of
 * CPUs.
 *
 * Params:
 *      pb = The packbuilder
 *      n = Number of threads to spawn
 *
 * Returns: number of actual threads to be used
 */
//GIT_EXTERN
uint git_packbuilder_set_threads(libgit2_d.types.git_packbuilder* pb, uint n);

/**
 * Insert a single object
 *
 * For an optimal pack it's mandatory to insert objects in recency order,
 * commits followed by trees and blobs.
 *
 * Params:
 *      pb = The packbuilder
 *      id = The oid of the commit
 *      name = The name; might be null
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_packbuilder_insert(libgit2_d.types.git_packbuilder* pb, const (libgit2_d.oid.git_oid)* id, const (char)* name);

/**
 * Insert a root tree object
 *
 * This will add the tree as well as all referenced trees and blobs.
 *
 * Params:
 *      pb = The packbuilder
 *      id = The oid of the root tree
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_packbuilder_insert_tree(libgit2_d.types.git_packbuilder* pb, const (libgit2_d.oid.git_oid)* id);

/**
 * Insert a commit object
 *
 * This will add a commit as well as the completed referenced tree.
 *
 * Params:
 *      pb = The packbuilder
 *      id = The oid of the commit
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_packbuilder_insert_commit(libgit2_d.types.git_packbuilder* pb, const (libgit2_d.oid.git_oid)* id);

/**
 * Insert objects as given by the walk
 *
 * Those commits and all objects they reference will be inserted into
 * the packbuilder.
 *
 * Params:
 *      pb = the packbuilder
 *      walk = the revwalk to use to fill the packbuilder
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_packbuilder_insert_walk(libgit2_d.types.git_packbuilder* pb, libgit2_d.types.git_revwalk* walk);

/**
 * Recursively insert an object and its referenced objects
 *
 * Insert the object as well as any object it references.
 *
 * Params:
 *      pb = the packbuilder
 *      id = the id of the root object to insert
 *      name = optional name for the object
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_packbuilder_insert_recur(libgit2_d.types.git_packbuilder* pb, const (libgit2_d.oid.git_oid)* id, const (char)* name);

/**
 * Write the contents of the packfile to an in-memory buffer
 *
 * The contents of the buffer will become a valid packfile, even though there
 * will be no attached index
 *
 * Params:
 *      buf = Buffer where to write the packfile
 *      pb = The packbuilder
 */
//GIT_EXTERN
int git_packbuilder_write_buf(libgit2_d.buffer.git_buf* buf, libgit2_d.types.git_packbuilder* pb);

/**
 * Write the new pack and corresponding index file to path.
 *
 * Params:
 *      pb = The packbuilder
 *      path = Path to the directory where the packfile and index should be stored, or NULL for default location
 *      mode = permissions to use creating a packfile or 0 for defaults
 *      progress_cb = function to call with progress information from the indexer (optional)
 *      progress_cb_payload = payload for the progress callback (optional)
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_packbuilder_write(libgit2_d.types.git_packbuilder* pb, const (char)* path, uint mode, libgit2_d.indexer.git_indexer_progress_cb progress_cb, void* progress_cb_payload);

/**
 * Get the packfile's hash
 *
 * A packfile's name is derived from the sorted hashing of all object
 * names. This is only correct after the packfile has been written.
 *
 * Params:
 *      pb = The packbuilder object
 */
//GIT_EXTERN
const (libgit2_d.oid.git_oid)* git_packbuilder_hash(libgit2_d.types.git_packbuilder* pb);

/**
 * Callback used to iterate over packed objects
 *
 * @see git_packbuilder_foreach
 *
 * Params:
 *      buf = A pointer to the object's data
 *      size = The size of the underlying object
 *      payload = Payload passed to git_packbuilder_foreach
 *
 * Returns: non-zero to terminate the iteration
 */
alias git_packbuilder_foreach_cb = int function(void* buf, size_t size, void* payload);

/**
 * Create the new pack and pass each object to the callback
 *
 * Params:
 *      pb = the packbuilder
 *      cb = the callback to call with each packed object's buffer
 *      payload = the callback's data
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_packbuilder_foreach(libgit2_d.types.git_packbuilder* pb, .git_packbuilder_foreach_cb cb, void* payload);

/**
 * Get the total number of objects the packbuilder will write out
 *
 * Params:
 *      pb = the packbuilder
 *
 * Returns: the number of objects in the packfile
 */
//GIT_EXTERN
size_t git_packbuilder_object_count(libgit2_d.types.git_packbuilder* pb);

/**
 * Get the number of objects the packbuilder has already written out
 *
 * Params:
 *      pb = the packbuilder
 *
 * Returns: the number of objects which have already been written
 */
//GIT_EXTERN
size_t git_packbuilder_written(libgit2_d.types.git_packbuilder* pb);

/**
 * Packbuilder progress notification function
 */
alias git_packbuilder_progress = int function(int stage, uint current, uint total, void* payload);

/**
 * Set the callbacks for a packbuilder
 *
 * Params:
 *      pb = The packbuilder object
 *      progress_cb = Function to call with progress information during pack building. Be aware that this is called inline with pack building operations, so performance may be affected.
 *      progress_cb_payload = Payload for progress callback.
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_packbuilder_set_callbacks(libgit2_d.types.git_packbuilder* pb, .git_packbuilder_progress progress_cb, void* progress_cb_payload);

/**
 * Free the packbuilder and all associated data
 *
 * Params:
 *      pb = The packbuilder
 */
//GIT_EXTERN
void git_packbuilder_free(libgit2_d.types.git_packbuilder* pb);

/** @} */
