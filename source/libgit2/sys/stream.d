/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2.sys.stream;


private static import core.sys.posix.sys.types;
private static import libgit2.proxy;
private static import libgit2.types;

extern (C):
nothrow @nogc:
package(libgit2):

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
	int function(libgit2.types.git_cert**,  .git_stream*) certificate;
	int function(.git_stream*, const (libgit2.proxy.git_proxy_options)* proxy_opts) set_proxy;
	core.sys.posix.sys.types.ssize_t function(.git_stream*, void*, size_t) read;
	core.sys.posix.sys.types.ssize_t function(.git_stream*, const (char)*, size_t, int) write;
	int function(.git_stream*) close;
	void function(.git_stream*) free;
}

struct git_stream_registration
{
	/**
	 * The `version` field should be set to `GIT_STREAM_VERSION`.
	 */
	int version_;

	/**
	 * Called to create a new connection to a given host.
	 *
	 * Params:
	 *      out_ = The created stream
	 *      host = The hostname to connect to; may be a hostname or IP address
	 *      port = The port to connect to; may be a port number or service name
	 *
	 * Returns: 0 or an error code
	 */
	int function(.git_stream** out_, const (char)* host, const (char)* port) init;

	/**
	 * Called to create a new connection on top of the given stream.  If
	 * this is a TLS stream, then this function may be used to proxy a
	 * TLS stream over an HTTP CONNECT session.  If this is unset, then
	 * HTTP CONNECT proxies will not be supported.
	 *
	 * Params:
	 *      out_ = The created stream
	 *      in = An existing stream to add TLS to
	 *      host = The hostname that the stream is connected to, for certificate validation
	 *
	 * Returns: 0 or an error code
	 */
	int function(.git_stream** out_, .git_stream* in_, const (char)* host) wrap;
}

/**
 * The type of stream to register.
 */
enum git_stream_t
{
	/**
	 * A standard (non-TLS) socket.
	 */
	GIT_STREAM_STANDARD = 1,

	/**
	 * A TLS-encrypted socket.
	 */
	GIT_STREAM_TLS = 2,
}

//Declaration name in C language
enum
{
	GIT_STREAM_STANDARD = .git_stream_t.GIT_STREAM_STANDARD,
	GIT_STREAM_TLS = .git_stream_t.GIT_STREAM_TLS,
}

/**
 * Register stream constructors for the library to use
 *
 * If a registration structure is already set, it will be overwritten.
 * Pass `NULL` in order to deregister the current constructor and return
 * to the system defaults.
 *
 * The type parameter may be a bitwise AND of types.
 *
 * Params:
 *      type = the type or types of stream to register
 *      registration = the registration data
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_stream_register(.git_stream_t type, .git_stream_registration* registration);

deprecated:

version (GIT_DEPRECATE_HARD) {
} else {
	/* @name Deprecated TLS Stream Registration Functions
	 *
	 * These functions are retained for backward compatibility.  The newer
	 * versions of these values should be preferred in all new code.
	 *
	 * There is no plan to remove these backward compatibility values at
	 * this time.
	 */
	/*@{*/

	/*
	 * @deprecated Provide a git_stream_registration to git_stream_register
	 * @see git_stream_registration
	 */
	alias git_stream_cb = int function(.git_stream** out_, const (char)* host, const (char)* port);

	/**
	 * Register a TLS stream constructor for the library to use.  This stream
	 * will not support HTTP CONNECT proxies.  This internally calls
	 * `git_stream_register` and is preserved for backward compatibility.
	 *
	 * This function is deprecated, but there is no plan to remove this
	 * function at this time.
	 *
	 * @deprecated Provide a git_stream_registration to git_stream_register
	 * @see git_stream_register
	 */
	//GIT_EXTERN
	int git_stream_register_tls(.git_stream_cb ctor);
}
