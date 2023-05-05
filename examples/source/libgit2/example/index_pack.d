module libgit2.example.index_pack;


private static import core.stdc.stdio;
private static import core.stdc.stdlib;
private static import libgit2.example.common;
private static import libgit2.indexer;
private static import libgit2.oid;
private static import libgit2.repository;
private static import libgit2.types;

/**
 * This could be run in the main loop whilst the application waits for
 * the indexing to finish in a worker thread
 */
nothrow @nogc
private int index_cb(const (libgit2.indexer.git_indexer_progress)* stats, void* data)

	in
	{
	}

	do
	{
		//cast(void)(data);
		core.stdc.stdio.printf("\rProcessing %u of %u", stats.indexed_objects, stats.total_objects);

		return 0;
	}

extern (C)
nothrow @nogc
public int lg2_index_pack(libgit2.types.git_repository* repo, int argc, char** argv)

	in
	{
	}

	do
	{
		//cast(void)(repo);

		if (argc < 2) {
			core.stdc.stdio.fprintf(core.stdc.stdio.stderr, "usage: %s index-pack <packfile>\n", argv[-1]);

			return core.stdc.stdlib.EXIT_FAILURE;
		}

		libgit2.indexer.git_indexer* idx = null;
		int error;

		version (GIT_EXPERIMENTAL_SHA256) {
			error = libgit2.indexer.git_indexer_new(&idx, ".", libgit2.repository.git_repository_oid_type(repo), null);
		} else {
			error = libgit2.indexer.git_indexer_new(&idx, ".", 0, null, null);
		}

		if (error < 0) {
			core.stdc.stdio.puts("bad idx");

			return -1;
		}

		int fd = libgit2.example.common.open(argv[1], 0);

		if (fd < 0) {
			core.stdc.stdio.perror("open");

			return -1;
		}

		libgit2.indexer.git_indexer_progress stats = {0, 0};
		libgit2.example.common.ssize_t read_bytes;
		char[512] buf;

		scope (exit) {
			libgit2.example.common.close(fd);
			libgit2.indexer.git_indexer_free(idx);
		}

		do {
			read_bytes = libgit2.example.common.read(fd, &(buf[0]), buf.length);

			if (read_bytes < 0) {
				break;
			}

			error = libgit2.indexer.git_indexer_append(idx, &(buf[0]), read_bytes, &stats);

			if (error < 0) {
				return error;
			}

			.index_cb(&stats, null);
		} while (read_bytes > 0);

		if (read_bytes < 0) {
			error = -1;
			core.stdc.stdio.perror("failed reading");

			return error;
		}

		error = libgit2.indexer.git_indexer_commit(idx, &stats);

		if (error < 0) {
			return error;
		}

		core.stdc.stdio.printf("\rIndexing %u of %u\n", stats.indexed_objects, stats.total_objects);

		core.stdc.stdio.puts(libgit2.indexer.git_indexer_name(idx));

		return error;
	}
