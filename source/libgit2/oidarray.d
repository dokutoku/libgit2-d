/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
/**
 * License: GPL-2.0(Linking Exception)
 */
module libgit2.oidarray;


private static import libgit2.oid;
private import libgit2.common: GIT_EXTERN;

extern (C):
nothrow @nogc:
public:

/**
 * Array of object ids
 */
struct git_oidarray
{
	libgit2.oid.git_oid* ids;
	size_t count;
}

/**
 * Free the object IDs contained in an oid_array.  This method should
 * be called on `git_oidarray` objects that were provided by the
 * library.  Not doing so will result in a memory leak.
 *
 * This does not free the `git_oidarray` itself, since the library will
 * never allocate that object directly itself.
 *
 * Params:
 *      array = git_oidarray from which to free oid data
 */
@GIT_EXTERN
void git_oidarray_dispose(.git_oidarray* array);

/* @} */
