/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2_d.sys.stream;


private static import core.sys.posix.sys.types;
private static import libgit2_d.common;
private static import libgit2_d.proxy;
private static import libgit2_d.types;

extern (C):
nothrow @nogc:

enum GIT_STREAM_VERSION = 1;

version (Posix):

//ToDo: ssize_t

/**
 * Every stream must have this struct as its first element, so the
 * API can talk to it. You'd define your stream as
 *
 *     struct my_stream {
 *             .git_stream parent;
 *             ...
 *     }
 *
 * and fill the functions
 */
struct git_stream
{
	int version_;

	int encrypted;
	int proxy_support;
	int function(.git_stream*) connect;
	int function(libgit2_d.types.git_cert**,  .git_stream*) certificate;
	int function(.git_stream*, const (libgit2_d.proxy.git_proxy_options)* proxy_opts) set_proxy;
	core.sys.posix.sys.types.ssize_t function(.git_stream*, void*, size_t) read;
	core.sys.posix.sys.types.ssize_t function(.git_stream*, const (char)*, size_t, int) write;
	int function(.git_stream*) close;
	void function(.git_stream*) free;
}

alias git_stream_cb = int function(.git_stream** out_, const (char)* host, const (char)* port);

/**
 * Register a TLS stream constructor for the library to use
 *
 * If a constructor is already set, it will be overwritten. Pass
 * `null` in order to deregister the current constructor.
 *
 * @param ctor the constructor to use
 * @return 0 or an error code
 */
//GIT_EXTERN
int git_stream_register_tls(.git_stream_cb ctor);
