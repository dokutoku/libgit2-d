/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2_d.transport;


private static import libgit2_d.types;

/**
 * @file git2/transport.h
 * @brief Git transport interfaces and functions
 * @defgroup git_transport interfaces and functions
 * @ingroup Git
 * @{
 */
extern (C):
nothrow @nogc:
public:

/**
 * Callback for messages received by the transport.
 *
 * Return a negative value to cancel the network operation.
 *
 * Params:
 *      str = The message from the transport
 *      len = The length of the message
 *      payload = Payload provided by the caller
 */
alias git_transport_message_cb = int function(const (char)* str, int len, void* payload);

/**
 * Signature of a function which creates a transport
 */
alias git_transport_cb = int function(libgit2_d.types.git_transport** out_, libgit2_d.types.git_remote* owner, void* param);

/** @} */
