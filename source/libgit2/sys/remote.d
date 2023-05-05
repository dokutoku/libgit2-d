/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
/**
 * License: GPL-2.0(Linking Exception)
 */

module libgit2.sys.remote;


/*
 * @file git2/sys/remote.h
 * @brief Low-level remote functionality for custom transports
 * @defgroup git_remote Low-level remote functionality
 * @ingroup Git
 * @{
*/
extern (C):
nothrow @nogc:

enum git_remote_capability_t
{
	/**
	 * Remote supports fetching an advertised object by ID.
	 */
	GIT_REMOTE_CAPABILITY_TIP_OID = 1 << 0,

	/**
	 * Remote supports fetching an individual reachable object.
	 */
	GIT_REMOTE_CAPABILITY_REACHABLE_OID = 1 << 1,
}

//Declaration name in C language
enum
{
	GIT_REMOTE_CAPABILITY_TIP_OID = .git_remote_capability_t.GIT_REMOTE_CAPABILITY_TIP_OID,
	GIT_REMOTE_CAPABILITY_REACHABLE_OID = .git_remote_capability_t.GIT_REMOTE_CAPABILITY_REACHABLE_OID,
}

/* @} */
