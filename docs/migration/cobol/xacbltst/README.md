# COBOL Wrapper for External XACBLTST Service

This folder provides a sample IBM i COBOL program (`XACBLTSTWS`) that replaces the original `CALL 'XACBLTST'` with an HTTPS call to the ASP.NET Core service. It relies on Db2 for i HTTP functions so no additional third-party service programs are required.

## Usage Pattern

1. Ensure the IBM i partition has network access to the ASP.NET Core endpoint and that the certificate authority is stored in DCM.
2. Set the `XACONCAT_URL` environment variable to the external service base URL (e.g., `https://api.example.com`); `XACBLTST-CLIENT.CBL` appends `/api/v1/concat`.
3. Replace `CALL 'XACBLTST'` with `CALL 'XACBLTSTWS'` in dependent programs.
4. Compile the program with SQL (`CRTSQLCBLI OBJLIB(MODERN) SRCFILE(QCBLSRC) SRCMBR(XACBLTSTWS) COMMIT(*NONE)`).

The sample demonstrates:

- Converting EBCDIC parameters into UTF-8 JSON.
- Posting the payload via `SYSTOOLS.HTTPPOSTCLOB`.
- Handling HTTP errors and falling back to the original COBOL subroutine when the web call fails.

## Next Steps

- Extract the HTTP call into a service program once multiple modules adopt this pattern.
- Consider caching responses if the utility becomes chatty.
