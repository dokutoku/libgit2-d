/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2_d.sys.transport;


private static import libgit2_d.cert;
private static import libgit2_d.credential;
private static import libgit2_d.indexer;
private static import libgit2_d.proxy;
private static import libgit2_d.strarray;
private static import libgit2_d.sys.credential;
private static import libgit2_d.transport;
private static import libgit2_d.types;

/**
 * @file git2/sys/transport.h
 * @brief Git custom transport registration interfaces and functions
 * @defgroup git_transport Git custom transport registration
 * @ingroup Git
 * @{
 */

extern (C):
nothrow @nogc:
package(libgit2_d):

/**
 * Flags to pass to transport
 *
 * Currently unused.
 */
enum git_transport_flags_t
{
	GIT_TRANSPORTFLAGS_NONE = 0,
}

//Declaration name in C language
enum
{
	GIT_TRANSPORTFLAGS_NONE = .git_transport_flags_t.GIT_TRANSPORTFLAGS_NONE,
}

struct git_transport
{
	/**
	 * The struct version
	 */
	uint version_;

	/**
	 * Set progress and error callbacks
	 */
	int function(.git_transport* transport, libgit2_d.transport.git_transport_message_cb progress_cb, libgit2_d.transport.git_transport_message_cb error_cb, libgit2_d.cert.git_transport_certificate_check_cb certificate_check_cb, void* payload) set_callbacks;

	/**
	 * Set custom headers for HTTP requests
	 */
	int function(.git_transport* transport, const (libgit2_d.strarray.git_strarray)* custom_headers) set_custom_headers;

	/**
	 * Connect the transport to the remote repository, using the given
	 * direction.
	 */
	int function(.git_transport* transport, const (char)* url, libgit2_d.credential.git_credential_acquire_cb cred_acquire_cb, void* cred_acquire_payload, const (libgit2_d.proxy.git_proxy_options)* proxy_opts, int direction, int flags) connect;

	/**
	 * Get the list of available references in the remote repository.
	 *
	 * This function may be called after a successful call to
	 * `connect()`. The array returned is owned by the transport and
	 * must be kept valid until the next call to one of its functions.
	 */
	int function(const (libgit2_d.types.git_remote_head)*** out_, size_t* size, .git_transport* transport) ls;

	/**
	 * Executes the push whose context is in the git_push object.
	 */
	int function(.git_transport* transport, libgit2_d.types.git_push* push, const (libgit2_d.types.git_remote_callbacks)* callbacks) push;

	/**
	 * Negotiate a fetch with the remote repository.
	 *
	 * This function may be called after a successful call to `connect()`,
	 * when the direction is git_direction.GIT_DIRECTION_FETCH. The function performs a
	 * negotiation to calculate the `wants` list for the fetch.
	 */
	int function(.git_transport* transport, libgit2_d.types.git_repository* repo, const (libgit2_d.types.git_remote_head)* /+ const +/ * refs, size_t count) negotiate_fetch;

	/**
	 * Start downloading the packfile from the remote repository.
	 *
	 * This function may be called after a successful call to
	 * negotiate_fetch(), when the direction is git_direction.GIT_DIRECTION_FETCH.
	 */
	int function(.git_transport* transport, libgit2_d.types.git_repository* repo, libgit2_d.indexer.git_indexer_progress* stats, libgit2_d.indexer.git_indexer_progress_cb progress_cb, void* progress_payload) download_pack;

	/**
	 * Checks to see if the transport is connected
	 */
	int function(.git_transport* transport) is_connected;

	/**
	 * Reads the flags value previously passed into connect()
	 */
	int function(.git_transport* transport, int* flags) read_flags;

	/**
	 * Cancels any outstanding transport operation
	 */
	void function(.git_transport* transport) cancel;

	/**
	 * Close the connection to the remote repository.
	 *
	 * This function is the reverse of connect() -- it terminates the
	 * connection to the remote end.
	 */
	int function(.git_transport* transport) close;

	/**
	 * Frees/destructs the git_transport object.
	 */
	void function(.git_transport* transport) free;
}

enum GIT_TRANSPORT_VERSION = 1;

pragma(inline, true)
pure nothrow @safe @nogc
.git_transport GIT_TRANSPORT_INIT()

	do
	{
		.git_transport OUTPUT =
		{
			version_: .GIT_TRANSPORT_VERSION,
		};

		return OUTPUT;
	}

/**
 * Initializes a `git_transport` with default values. Equivalent to
 * creating an instance with GIT_TRANSPORT_INIT.
 *
 * Params:
 *      opts = the `git_transport` struct to initialize
 *      version = Version of struct; pass `GIT_TRANSPORT_VERSION`
 *
 * Returns: Zero on success; -1 on failure.
 */
//GIT_EXTERN
int git_transport_init(.git_transport* opts, uint version_);

/**
 * Function to use to create a transport from a URL. The transport database
 * is scanned to find a transport that implements the scheme of the URI (i.e.
 * git:// or http://) and a transport object is returned to the caller.
 *
 * Params:
 *      out_ = The newly created transport (out)
 *      owner = The git_remote which will own this transport
 *      url = The URL to connect to
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_transport_new(.git_transport** out_, libgit2_d.types.git_remote* owner, const (char)* url);

/**
 * Create an ssh transport with custom git command paths
 *
 * This is a factory function suitable for setting as the transport
 * callback in a remote (or for a clone in the options).
 *
 * The payload argument must be a strarray pointer with the paths for
 * the `git-upload-pack` and `git-receive-pack` at index 0 and 1.
 *
 * Params:
 *      out_ = the resulting transport
 *      owner = the owning remote
 *      payload = a strarray with the paths
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_transport_ssh_with_paths(.git_transport** out_, libgit2_d.types.git_remote* owner, void* payload);

/**
 * Add a custom transport definition, to be used in addition to the built-in
 * set of transports that come with libgit2.
 *
 * The caller is responsible for synchronizing calls to git_transport_register
 * and git_transport_unregister with other calls to the library that
 * instantiate transports.
 *
 * Params:
 *      prefix = The scheme (ending in "://") to match, i.e. "git://"
 *      cb = The callback used to create an instance of the transport
 *      param = A fixed parameter to pass to cb at creation time
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_transport_register(const (char)* prefix, libgit2_d.transport.git_transport_cb cb, void* param);

/**
 * Unregister a custom transport definition which was previously registered
 * with git_transport_register.
 *
 * The caller is responsible for synchronizing calls to git_transport_register
 * and git_transport_unregister with other calls to the library that
 * instantiate transports.
 *
 * Params:
 *      prefix = From the previous call to git_transport_register
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_transport_unregister(const (char)* prefix);

/*
 * Transports which come with libgit2 (match git_transport_cb). The expected
 * value for "param" is listed in-line below.
 */

/**
 * Create an instance of the dummy transport.
 *
 * Params:
 *      out_ = The newly created transport (out)
 *      owner = The git_remote which will own this transport
 *      payload = You must pass null for this parameter.
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_transport_dummy(.git_transport** out_, libgit2_d.types.git_remote* owner, /* null */ void* payload);

/**
 * Create an instance of the local transport.
 *
 * Params:
 *      out_ = The newly created transport (out)
 *      owner = The git_remote which will own this transport
 *      payload = You must pass null for this parameter.
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_transport_local(.git_transport** out_, libgit2_d.types.git_remote* owner, /* null */ void* payload);

/**
 * Create an instance of the smart transport.
 *
 * Params:
 *      out_ = The newly created transport (out)
 *      owner = The git_remote which will own this transport
 *      payload = A pointer to a git_smart_subtransport_definition
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_transport_smart(.git_transport** out_, libgit2_d.types.git_remote* owner, /* (git_smart_subtransport_definition *) */ void* payload);

/**
 * Call the certificate check for this transport.
 *
 * Params:
 *      transport = a smart transport
 *      cert = the certificate to pass to the caller
 *      valid = whether we believe the certificate is valid
 *      hostname = the hostname we connected to
 *
 * Returns: the return value of the callback: 0 for no error, git_error_code.GIT_PASSTHROUGH to indicate that there is no callback registered (or the callback refused to validate the certificate and callers should behave as if no callback was set), or < 0 for an error
 */
//GIT_EXTERN
int git_transport_smart_certificate_check(.git_transport* transport, libgit2_d.types.git_cert* cert, int valid, const (char)* hostname);

/**
 * Call the credentials callback for this transport
 *
 * Params:
 *      out_ = the pointer where the creds are to be stored
 *      transport = a smart transport
 *      user = the user we saw on the url (if any)
 *      methods = available methods for authentication
 *
 * Returns: the return value of the callback: 0 for no error, git_error_code.GIT_PASSTHROUGH to indicate that there is no callback registered (or the callback refused to provide credentials and callers should behave as if no callback was set), or < 0 for an error
 */
//GIT_EXTERN
int git_transport_smart_credentials(libgit2_d.sys.credential.git_credential** out_, .git_transport* transport, const (char)* user, int methods);

/**
 * Get a copy of the proxy options
 *
 * The url is copied and must be freed by the caller.
 *
 * Params:
 *      out_ = options struct to fill
 *      transport = the transport to extract the data from.
 */
//GIT_EXTERN
int git_transport_smart_proxy_options(libgit2_d.proxy.git_proxy_options* out_, .git_transport* transport);

/*
 *** End of base transport interface ***
 *** Begin interface for subtransports for the smart transport ***
 */

/**
 * Actions that the smart transport can ask a subtransport to perform
 */
enum git_smart_service_t
{
	GIT_SERVICE_UPLOADPACK_LS = 1,
	GIT_SERVICE_UPLOADPACK = 2,
	GIT_SERVICE_RECEIVEPACK_LS = 3,
	GIT_SERVICE_RECEIVEPACK = 4,
}

//Declaration name in C language
enum
{
	GIT_SERVICE_UPLOADPACK_LS = .git_smart_service_t.GIT_SERVICE_UPLOADPACK_LS,
	GIT_SERVICE_UPLOADPACK = .git_smart_service_t.GIT_SERVICE_UPLOADPACK,
	GIT_SERVICE_RECEIVEPACK_LS = .git_smart_service_t.GIT_SERVICE_RECEIVEPACK_LS,
	GIT_SERVICE_RECEIVEPACK = .git_smart_service_t.GIT_SERVICE_RECEIVEPACK,
}

/**
 * A stream used by the smart transport to read and write data
 * from a subtransport.
 *
 * This provides a customization point in case you need to
 * support some other communication method.
 */
struct git_smart_subtransport_stream
{
	/**
	 * The owning subtransport
	 */
	.git_smart_subtransport* subtransport;

	/**
	 * Read available data from the stream.
	 *
	 * The implementation may read less than requested.
	 */
	int function(.git_smart_subtransport_stream* stream, char* buffer, size_t buf_size, size_t* bytes_read) read;

	/**
	 * Write data to the stream
	 *
	 * The implementation must write all data or return an error.
	 */
	int function(.git_smart_subtransport_stream* stream, const (char)* buffer, size_t len) write;

	/**
	 * Free the stream
	 */
	void function(.git_smart_subtransport_stream* stream) free;
}

/**
 * An implementation of a subtransport which carries data for the
 * smart transport
 */
struct git_smart_subtransport
{
	/**
	 * Setup a subtransport stream for the requested action.
	 */
	int function(.git_smart_subtransport_stream** out_, .git_smart_subtransport* transport, const (char)* url, .git_smart_service_t action) action;

	/**
	 * Close the subtransport.
	 *
	 * Subtransports are guaranteed a call to close() between
	 * calls to action(), except for the following two "natural" progressions
	 * of actions against a constant URL:
	 *
	 * - UPLOADPACK_LS -> UPLOADPACK
	 * - RECEIVEPACK_LS -> RECEIVEPACK
	 */
	int function(.git_smart_subtransport* transport) close;

	/**
	 * Free the subtransport
	 */
	void function(.git_smart_subtransport* transport) free;
}

/**
 * A function which creates a new subtransport for the smart transport
 */
alias git_smart_subtransport_cb = int function(.git_smart_subtransport** out_, .git_transport* owner, void* param);

/**
 * Definition for a "subtransport"
 *
 * The smart transport knows how to speak the git protocol, but it has no
 * knowledge of how to establish a connection between it and another endpoint,
 * or how to move data back and forth. For this, a subtransport interface is
 * declared, and the smart transport delegates this work to the subtransports.
 *
 * Three subtransports are provided by libgit2: ssh, git, http(s).
 *
 * Subtransports can either be RPC = 0 (persistent connection) or RPC = 1
 * (request/response). The smart transport handles the differences in its own
 * logic. The git subtransport is RPC = 0, while http is RPC = 1.
 */
struct git_smart_subtransport_definition
{
	/**
	 * The function to use to create the git_smart_subtransport
	 */
	.git_smart_subtransport_cb callback;

	/**
	 * True if the protocol is stateless; false otherwise. For example,
	 * http:// is stateless, but git:// is not.
	 */
	uint rpc;

	/**
	 * User-specified parameter passed to the callback
	 */
	void* param;
}

/* Smart transport subtransports that come with libgit2 */

/**
 * Create an instance of the http subtransport.
 *
 * This subtransport also supports https.
 *
 * Params:
 *      out_ = The newly created subtransport
 *      owner = The smart transport to own this subtransport
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_smart_subtransport_http(.git_smart_subtransport** out_, .git_transport* owner, void* param);

/**
 * Create an instance of the git subtransport.
 *
 * Params:
 *      out_ = The newly created subtransport
 *      owner = The smart transport to own this subtransport
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_smart_subtransport_git(.git_smart_subtransport** out_, .git_transport* owner, void* param);

/**
 * Create an instance of the ssh subtransport.
 *
 * Params:
 *      out_ = The newly created subtransport
 *      owner = The smart transport to own this subtransport
 *
 * Returns: 0 or an error code
 */
//GIT_EXTERN
int git_smart_subtransport_ssh(.git_smart_subtransport** out_, .git_transport* owner, void* param);

/** @} */
