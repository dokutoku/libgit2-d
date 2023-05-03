/*
 * Copyright (C) the libgit2 contributors. All rights reserved.
 *
 * This file is part of libgit2, distributed under the GNU GPL v2 with
 * a Linking Exception. For full terms see the included COPYING file.
 */
/**
 * License: GPL-2.0(Linking Exception)
 */
module libgit2.sys.cred;


extern (C):
nothrow @nogc:
package(libgit2):

/* These declarations have moved. */
version (GIT_DEPRECATE_HARD) {
} else {
	import libgit2.sys.credential;
}
