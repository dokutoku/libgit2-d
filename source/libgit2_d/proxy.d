/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2_d.proxy;


private static import libgit2_d.cert;
private static import libgit2_d.cred;

extern (C):
nothrow @nogc:
public:

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
	 * Returning git_error_code.GIT_PASSTHROUGH will make libgit2 behave as
	 * though this field isn't set.
	 */
	libgit2_d.cred.git_cred_acquire_cb credentials;

	/**
	 * If cert verification fails, this will be called to let the
	 * user make the final decision of whether to allow the
	 * connection to proceed. Returns 0 to allow the connection
	 * or a negative value to indicate an error.
	 */
	libgit2_d.cert.git_transport_certificate_check_cb certificate_check;

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
 * Initialize git_proxy_options structure
 *
 * Initializes a `git_proxy_options` with default values. Equivalent to
 * creating an instance with `GIT_PROXY_OPTIONS_INIT`.
 *
 * @param opts The `git_proxy_options` struct to initialize.
 * @param version The struct version; pass `GIT_PROXY_OPTIONS_VERSION`.
 * @return Zero on success; -1 on failure.
 */
//GIT_EXTERN
int git_proxy_options_init(.git_proxy_options* opts, uint version_);
