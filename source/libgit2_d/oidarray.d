/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2_d.oidarray;


private static import libgit2_d.oid;

extern (C):
nothrow @nogc:
public:

/**
 * Array of object ids
 */
struct git_oidarray
{
	libgit2_d.oid.git_oid* ids;
	size_t count;
}

/**
 * Free the OID array
 *
 * This method must (and must only) be called on `git_oidarray`
 * objects where the array is allocated by the library. Not doing so,
 * will result in a memory leak.
 *
 * This does not free the `git_oidarray` itself, since the library will
 * never allocate that object directly itself (it is more commonly embedded
 * inside another struct or created on the stack).
 *
 * Params:
 *      array = git_oidarray from which to free oid data
 */
//GIT_EXTERN
void git_oidarray_free(.git_oidarray* array);

/* @} */
