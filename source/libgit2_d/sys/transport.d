/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2_d.sys.transport;


private static import libgit2_d.net;
private static import libgit2_d.proxy;
private static import libgit2_d.strarray;
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

/**
 * Flags to pass to transport
 *
 * Currently unused.
 */
enum git_transport_flags_t
{
	GIT_TRANSPORTFLAGS_NONE = 0,
}

struct git_transport
{
	uint version_;
	/* Set progress and error callbacks */
	int function(.git_transport* transport, libgit2_d.types.git_transport_message_cb progress_cb, libgit2_d.types.git_transport_message_cb error_cb, libgit2_d.types.git_transport_certificate_check_cb certificate_check_cb, void* payload) set_callbacks;

	/* Set custom headers for HTTP requests */
	int function(.git_transport* transport, const (libgit2_d.strarray.git_strarray)* custom_headers) set_custom_headers;

	/*
	 * Connect the transport to the remote repository, using the given
	 * direction.
	 */
	int function(.git_transport* transport, const (char)* url, libgit2_d.transport.git_cred_acquire_cb cred_acquire_cb, void* cred_acquire_payload, const (libgit2_d.proxy.git_proxy_options)* proxy_opts, int direction, int flags) connect;

	/*
	 * This function may be called after a successful call to
	 * connect(). The array returned is owned by the transport and
	 * is guaranteed until the next call of a transport function.
	 */
	int function(const (libgit2_d.net.git_remote_head)*** out_, size_t* size, .git_transport* transport) ls;

	/* Executes the push whose context is in the git_push object. */
	int function(.git_transport* transport, libgit2_d.types.git_push* push, const (libgit2_d.remote.git_remote_callbacks)* callbacks) push;

	/*
	 * This function may be called after a successful call to connect(), when
	 * the direction is FETCH. The function performs a negotiation to calculate
	 * the wants list for the fetch.
	 */
	int function(.git_transport* transport, libgit2_d.types.git_repository* repo, const (libgit2_d.net.git_remote_head)* /+ const +/ * refs, size_t count) negotiate_fetch;

	/*
	 * This function may be called after a successful call to negotiate_fetch(),
	 * when the direction is FETCH. This function retrieves the pack file for
	 * the fetch from the remote end.
	 */
	int function(.git_transport* transport, libgit2_d.types.git_repository* repo, libgit2_d.types.git_transfer_progress* stats, libgit2_d.types.git_transfer_progress_cb progress_cb, void* progress_payload) download_pack;

	/* Checks to see if the transport is connected */
	int function(.git_transport* transport) is_connected;

	/* Reads the flags value previously passed into connect() */
	int function(.git_transport* transport, int* flags) read_flags;

	/* Cancels any outstanding transport operation */
	void function(.git_transport* transport) cancel;

	/*
	 * This function is the reverse of connect() -- it terminates the
	 * connection to the remote end.
	 */
	int function(.git_transport* transport) close;

	/* Frees/destructs the git_transport object. */
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
 * @param opts the `git_transport` struct to initialize
 * @param version Version of struct; pass `GIT_TRANSPORT_VERSION`
 * @return Zero on success; -1 on failure.
 */
//GIT_EXTERN
int git_transport_init(.git_transport* opts, uint version_);

/**
 * Function to use to create a transport from a URL. The transport database
 * is scanned to find a transport that implements the scheme of the URI (i.e.
 * git:// or http://) and a transport object is returned to the caller.
 *
 * @param out_ The newly created transport (out)
 * @param owner The git_remote which will own this transport
 * @param url The URL to connect to
 * @return 0 or an error code
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
 * @param out_ the resulting transport
 * @param owner the owning remote
 * @param payload a strarray with the paths
 * @return 0 or an error code
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
 * @param prefix The scheme (ending in "://") to match, i.e. "git://"
 * @param cb The callback used to create an instance of the transport
 * @param param A fixed parameter to pass to cb at creation time
 * @return 0 or an error code
 */
//GIT_EXTERN
int git_transport_register(const (char)* prefix, libgit2_d.transport.git_transport_cb cb, void* param);

/**
 *
 * Unregister a custom transport definition which was previously registered
 * with git_transport_register.
 *
 * @param prefix From the previous call to git_transport_register
 * @return 0 or an error code
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
 * @param out_ The newly created transport (out)
 * @param owner The git_remote which will own this transport
 * @param payload You must pass null for this parameter.
 * @return 0 or an error code
 */
//GIT_EXTERN
int git_transport_dummy(.git_transport** out_, libgit2_d.types.git_remote* owner, /* null */ void* payload);

/**
 * Create an instance of the local transport.
 *
 * @param out_ The newly created transport (out)
 * @param owner The git_remote which will own this transport
 * @param payload You must pass null for this parameter.
 * @return 0 or an error code
 */
//GIT_EXTERN
int git_transport_local(.git_transport** out_, libgit2_d.types.git_remote* owner, /* null */ void* payload);

/**
 * Create an instance of the smart transport.
 *
 * @param out_ The newly created transport (out)
 * @param owner The git_remote which will own this transport
 * @param payload A pointer to a git_smart_subtransport_definition
 * @return 0 or an error code
 */
//GIT_EXTERN
int git_transport_smart(.git_transport** out_, libgit2_d.types.git_remote* owner, /* (git_smart_subtransport_definition *) */ void* payload);

/**
 * Call the certificate check for this transport.
 *
 * @param transport a smart transport
 * @param cert the certificate to pass to the caller
 * @param valid whether we believe the certificate is valid
 * @param hostname the hostname we connected to
 * @return the return value of the callback
 */
//GIT_EXTERN
int git_transport_smart_certificate_check(.git_transport* transport, libgit2_d.types.git_cert* cert, int valid, const (char)* hostname);

/**
 * Call the credentials callback for this transport
 *
 * @param out_ the pointer where the creds are to be stored
 * @param transport a smart transport
 * @param user the user we saw on the url (if any)
 * @param methods available methods for authentication
 * @return the return value of the callback
 */
//GIT_EXTERN
int git_transport_smart_credentials(libgit2_d.transport.git_cred** out_, .git_transport* transport, const (char)* user, int methods);

/**
 * Get a copy of the proxy options
 *
 * The url is copied and must be freed by the caller.
 *
 * @param out_ options struct to fill
 * @param transport the transport to extract the data from.
 */
//GIT_EXTERN
int git_transport_smart_proxy_options(libgit2_d.proxy.git_proxy_options* out_, .git_transport* transport);

/*
 *** End of base transport interface ***
 *** Begin interface for subtransports for the smart transport ***
 */

/*
 * The smart transport knows how to speak the git protocol, but it has no
 * knowledge of how to establish a connection between it and another endpoint,
 * or how to move data back and forth. For this, a subtransport interface is
 * declared, and the smart transport delegates this work to the subtransports.
 * Three subtransports are implemented: git, http, and winhttp. (The http and
 * winhttp transports each implement both http and https.)
 */

/*
 * Subtransports can either be RPC = 0 (persistent connection) or RPC = 1
 * (request/response). The smart transport handles the differences in its own
 * logic. The git subtransport is RPC = 0, while http and winhttp are both
 * RPC = 1.
 */

/*
 * Actions that the smart transport can ask
 * a subtransport to perform
 */
enum git_smart_service_t
{
	GIT_SERVICE_UPLOADPACK_LS = 1,
	GIT_SERVICE_UPLOADPACK = 2,
	GIT_SERVICE_RECEIVEPACK_LS = 3,
	GIT_SERVICE_RECEIVEPACK = 4,
}

/*
 * A stream used by the smart transport to read and write data
 * from a subtransport
 */
struct git_smart_subtransport_stream
{
	/* The owning subtransport */
	.git_smart_subtransport* subtransport;

	int function(.git_smart_subtransport_stream* stream, char* buffer, size_t buf_size, size_t* bytes_read) read;

	int function(.git_smart_subtransport_stream* stream, const (char)* buffer, size_t len) write;

	void function(.git_smart_subtransport_stream* stream) free;
}

/*
 * An implementation of a subtransport which carries data for the
 * smart transport
 */
struct git_smart_subtransport
{
	int function(.git_smart_subtransport_stream** out_, .git_smart_subtransport* transport, const (char)* url, .git_smart_service_t action) action;

	/*
	 * Subtransports are guaranteed a call to close() between
	 * calls to action(), except for the following two "natural" progressions
	 * of actions against a constant URL.
	 *
	 * 1. UPLOADPACK_LS -> UPLOADPACK
	 * 2. RECEIVEPACK_LS -> RECEIVEPACK
	 */
	int function(.git_smart_subtransport* transport) close;

	void function(.git_smart_subtransport* transport) free;
}

/* A function which creates a new subtransport for the smart transport */
alias git_smart_subtransport_cb = int function(.git_smart_subtransport** out_, .git_transport* owner, void* param);

/**
 * Definition for a "subtransport"
 *
 * This is used to let the smart protocol code know about the protocol
 * which you are implementing.
 */
struct git_smart_subtransport_definition
{
	/** The function to use to create the git_smart_subtransport */
	.git_smart_subtransport_cb callback;

	/**
	 * True if the protocol is stateless; false otherwise. For example,
	 * http:// is stateless, but git:// is not.
	 */
	uint rpc;

	/**
	 * Param of the callback
	 */
	void* param;
}

/* Smart transport subtransports that come with libgit2 */

/**
 * Create an instance of the http subtransport. This subtransport
 * also supports https. On Win32, this subtransport may be implemented
 * using the WinHTTP library.
 *
 * @param out_ The newly created subtransport
 * @param owner The smart transport to own this subtransport
 * @return 0 or an error code
 */
//GIT_EXTERN
int git_smart_subtransport_http(.git_smart_subtransport** out_, .git_transport* owner, void* param);

/**
 * Create an instance of the git subtransport.
 *
 * @param out_ The newly created subtransport
 * @param owner The smart transport to own this subtransport
 * @return 0 or an error code
 */
//GIT_EXTERN
int git_smart_subtransport_git(.git_smart_subtransport** out_, .git_transport* owner, void* param);

/**
 * Create an instance of the ssh subtransport.
 *
 * @param out_ The newly created subtransport
 * @param owner The smart transport to own this subtransport
 * @return 0 or an error code
 */
//GIT_EXTERN
int git_smart_subtransport_ssh(.git_smart_subtransport** out_, .git_transport* owner, void* param);

/** @} */
