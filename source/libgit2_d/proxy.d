/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2_d.proxy;


private static import libgit2_d.common;
private static import libgit2_d.transport;

extern (C):
nothrow @nogc:

/**
 * The type of proxy to use.
 */
enum git_proxy_t
{
	/**
	 * Do not attempt to connect through a proxy
	 *
	 * If built against libcurl, it itself may attempt to connect
	 * to a proxy if the environment variables specify it.
	 */
	GIT_PROXY_NONE,
	/**
	 * Try to auto-detect the proxy from the git configuration.
	 */
	GIT_PROXY_AUTO,
	/**
	 * Connect via the URL given in the options
	 */
	GIT_PROXY_SPECIFIED,
}

/**
 * Options for connecting through a proxy
 *
 * Note that not all types may be supported, depending on the platform
 * and compilation options.
 */
struct git_proxy_options
{
	uint version_;

	/**
	 * The type of proxy to use, by URL, auto-detect.
	 */
	.git_proxy_t type;

	/**
	 * The URL of the proxy.
	 */
	const (char)* url;

	/**
	 * This will be called if the remote host requires
	 * authentication in order to connect to it.
	 *
	 * Returning GIT_PASSTHROUGH will make libgit2 behave as
	 * though this field isn't set.
	 */
	libgit2_d.transport.git_cred_acquire_cb credentials;

	/**
	 * If cert verification fails, this will be called to let the
	 * user make the final decision of whether to allow the
	 * connection to proceed. Returns 1 to allow the connection, 0
	 * to disallow it or a negative value to indicate an error.
	 */
	libgit2_d.types.git_transport_certificate_check_cb certificate_check;

	/**
	 * Payload to be provided to the credentials and certificate
	 * check callbacks.
	 */
	void* payload;
}

enum GIT_PROXY_OPTIONS_VERSION = 1;

pragma(inline, true)
pure nothrow @safe @nogc
.git_proxy_options GIT_PROXY_OPTIONS_INIT()

	do
	{
		.git_proxy_options OUTPUT =
		{
			version_: .GIT_PROXY_OPTIONS_VERSION,
		};

		return OUTPUT;
	}

/**
 * Initialize a proxy options structure
 *
 * @param opts the options struct to initialize
 * @param version_ the version of the struct, use `GIT_PROXY_OPTIONS_VERSION`
 */
//GIT_EXTERN
int git_proxy_init_options(.git_proxy_options* opts, uint version_);
