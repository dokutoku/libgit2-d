/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2_d.net;


private static import libgit2_d.oid;

/**
 * @file git2/net.h
 * @brief Git networking declarations
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

enum GIT_DEFAULT_PORT = "9418";

/**
 * Direction of the connection.
 *
 * We need this because we need to know whether we should call
 * git-upload-pack or git-receive-pack on the remote end when get_refs
 * gets called.
 */
enum git_direction
{
	GIT_DIRECTION_FETCH = 0,
	GIT_DIRECTION_PUSH = 1,
}

//Declaration name in C language
enum
{
	GIT_DIRECTION_FETCH = .git_direction.GIT_DIRECTION_FETCH,
	GIT_DIRECTION_PUSH = .git_direction.GIT_DIRECTION_PUSH,
}

/**
 * Description of a reference advertised by a remote server, given out
 * on `ls` calls.
 */
struct git_remote_head
{
	/**
	 * available locally
	 */
	int local;

	libgit2_d.oid.git_oid oid;
	libgit2_d.oid.git_oid loid;
	char* name;

	/**
	 * If the server send a symref mapping for this ref, this will
	 * point to the target.
	 */
	char* symref_target;
}

/** @} */
