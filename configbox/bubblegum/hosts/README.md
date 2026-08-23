# Hosts 

This area is organized by the host operating system: [generic](./generic/README.md), [Windows](./windows/README.md), [macOS](./macos/README.md), and [Linux](./linux/README.md).  Under these will be providers that will run on the host sytems.


## Windows Hosts

### Virtualization-based Security (VBS)

**Virtualization-based Security (VBS)** is a feature in Windows that uses hardware virtualization and the Windows hypervisor to create an isolated, secure virtual environment. This protected space acts as a root of trust, shielding critical system secrets and credentials from the main operating system even if the kernel is compromised.

* **Virtual Secure Mode (VSM)**: A locked-down, lightweight virtual layer created by the hypervisor to separate vital system tasks from standard user and kernel processes.
* **Credential Guard**: Isolates sensitive login assets like NTLM hashes and Kerberos tickets to block pass-the-hash attacks.
* **Hypervisor-Enforced Code Integrity (HVCI)**: Ensures that only digitally signed, trusted code and drivers can run in kernel mode, stopping rootkits.

You can verify this is running with:

* `systeminfo`
* `bcdedit /enum`


## Links

* [Virtualization-Based Security (VBS) Defined](https://www.huntress.com/cybersecurity-101/topic/what-is-vbs)
* [MS Learn Virtualization-based Security (VBS)](https://learn.microsoft.com/windows-hardware/design/device-experiences/oem-vbs)

