/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
/**
 * License: GPL-2.0(Linking Exception)
 */
module libgit2.sys.midx;


private static import libgit2.buffer;
private static import libgit2.types;
private import libgit2.common: GIT_EXTERN;

/*
 * @file git2/midx.h
 * @brief Git multi-pack-index routines
 * @defgroup git_midx Git multi-pack-index routines
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:

/**
 * Create a new writer for `multi-pack-index` files.
 *
 * Params:
 *      out_ = location to store the writer pointer.
 *      pack_dir = the directory where the `.pack` and `.idx` files are. The `multi-pack-index` file will be written in this directory, too.
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_midx_writer_new(libgit2.types.git_midx_writer** out_, const (char)* pack_dir);

/**
 * Free the multi-pack-index writer and its resources.
 *
 * Params:
 *      w = the writer to free. If null no action is taken.
 */
@GIT_EXTERN
void git_midx_writer_free(libgit2.types.git_midx_writer* w);

/**
 * Add an `.idx` file to the writer.
 *
 * Params:
 *      w = the writer
 *      idx_path = the path of an `.idx` file.
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_midx_writer_add(libgit2.types.git_midx_writer* w, const (char)* idx_path);

/**
 * Write a `multi-pack-index` file to a file.
 *
 * Params:
 *      w = the writer
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_midx_writer_commit(libgit2.types.git_midx_writer* w);

/**
 * Dump the contents of the `multi-pack-index` to an in-memory buffer.
 *
 * Params:
 *      midx = Buffer where to store the contents of the `multi-pack-index`.
 *      w = the writer
 *
 * Returns: 0 or an error code
 */
@GIT_EXTERN
int git_midx_writer_dump(libgit2.buffer.git_buf* midx, libgit2.types.git_midx_writer* w);

/* @} */
