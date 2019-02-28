defmodule SSHKit.SCP do
  @moduledoc ~S"""
  Provides convenience functions for transferring files or directory trees to
  or from a remote host via SCP.

  Built on top of `SSHKit.SSH`.

  ## Common options

  These options are available for both uploads and downloads:

  * `:verbose` - let the remote scp process be verbose, default `false`
  * `:recursive` - set to `true` for copying directories, default `false`
  * `:preserve` - preserve timestamps, default `false`
  * `:timeout` - timeout in milliseconds, default `:infinity`

  ## Examples

  ```
  {:ok, conn} = SSHKit.SSH.connect("eg.io", user: "me")
  :ok = SSHKit.SCP.upload(conn, ".", "/home/code/phx", recursive: true)
  :ok = SSHKit.SSH.close(conn)
  ```
  """

  alias SSHKit.SCP.Download
  alias SSHKit.SCP.Upload

  @doc """
  Uploads a local file or directory to a remote host.

  ## Options

  See `SSHKit.SCP.Upload.transfer/4`.

  ## Example

  ```
  {:ok, upload} = SSHKit.SCP.upload(conn, ".", "/home/code/sshkit", recursive: true)
  ```
  """
  def upload(connection, source, target, options \\ []) do
    upload = Upload.init(source, target, options)

    with {:ok, upload} <- Upload.start(upload, connection) do
      Upload.loop(upload)
    end
  end

  @doc """
  Downloads a file or directory from a remote host.

  ## Options

  See `SSHKit.SCP.Download.transfer/4`.

  ## Example

  ```
  {:ok, download} = SSHKit.SCP.download(conn, "/home/code/sshkit", "downloads", recursive: true)
  ```
  """
  def download(connection, source, target, options \\ []) do
    download = Download.init(source, target, options)

    with {:ok, download} <- Download.start(download, connection) do
      Download.loop(download)
    end
  end
end
