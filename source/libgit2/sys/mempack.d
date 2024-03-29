/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
/**
 * License: GPL-2.0(Linking Exception)
 */
module libgit2.sys.mempack;


private static import libgit2.buffer;
private static import libgit2.types;
private import libgit2.common: GIT_EXTERN;

/*
 * @file git2/sys/mempack.h
 * @brief Custom ODB backend that permits packing objects in-memory
 * @defgroup git_backend Git custom backend APIs
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:

/**
 * Instantiate a new mempack backend.
 *
 * The backend must be added to an existing ODB with the highest
 * priority.
 *
 *     git_mempack_new(&mempacker);
 *     git_repository_odb(&odb, repository);
 *     git_odb_add_backend(odb, mempacker, 999);
 *
 * Once the backend has been loaded, all writes to the ODB will
 * instead be queued in memory, and can be finalized with
 * `git_mempack_dump`.
 *
 * Subsequent reads will also be served from the in-memory store
 * to ensure consistency, until the memory store is dumped.
 *
 * Params:
 *      out_ = Pointer where to store the ODB backend
 *
 * Returns: 0 on success; error code otherwise
 */
@GIT_EXTERN
int git_mempack_new(libgit2.types.git_odb_backend** out_);

/**
 * Dump all the queued in-memory writes to a packfile.
 *
 * The contents of the packfile will be stored in the given buffer.
 * It is the caller's responsibility to ensure that the generated
 * packfile is available to the repository (e.g. by writing it
 * to disk, or doing something crazy like distributing it across
 * several copies of the repository over a network).
 *
 * Once the generated packfile is available to the repository,
 * call `git_mempack_reset` to cleanup the memory store.
 *
 * Calling `git_mempack_reset` before the packfile has been
 * written to disk will result in an inconsistent repository
 * (the objects in the memory store won't be accessible).
 *
 * Params:
 *      pack = Buffer where to store the raw packfile
 *      repo = The active repository where the backend is loaded
 *      backend = The mempack backend
 *
 * Returns: 0 on success; error code otherwise
 */
@GIT_EXTERN
int git_mempack_dump(libgit2.buffer.git_buf* pack, libgit2.types.git_repository* repo, libgit2.types.git_odb_backend* backend);

/**
 * Reset the memory packer by clearing all the queued objects.
 *
 * This assumes that `git_mempack_dump` has been called before to
 * store all the queued objects into a single packfile.
 *
 * Alternatively, call `reset` without a previous dump to "undo"
 * all the recently written objects, giving transaction-like
 * semantics to the Git repository.
 *
 * Params:
 *      backend = The mempack backend
 *
 * Returns: 0 on success; error code otherwise
 */
@GIT_EXTERN
int git_mempack_reset(libgit2.types.git_odb_backend* backend);
