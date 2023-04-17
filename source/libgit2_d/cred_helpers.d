/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
module libgit2.cred_helpers;


extern (C):
nothrow @nogc:
public:

/* These declarations have moved. */
version (GIT_DEPRECATE_HARD) {
} else {
	import libgit2.credential_helpers;
}

