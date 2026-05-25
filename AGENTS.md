Do not create lab instructions that use hot keys (e.g. WindowsKey+R, WindowsKey+X).

When instructing learners to connect to a server, use the lab platform instead of local RDP:

1. Select **HOME** in the lab platform.
2. Select the target server from the **Select VM** dropdown.
3. Use the **Username** and **Password** values shown for the selected VM on the **HOME** tab.
4. Turn on **Enhanced mode** in the **Tools** section so the virtual machine uses the best screen resolution for the learner's monitor.

## Lab environment assumptions

Use the exact VM names shown in the lab platform and existing lab files. The course lab environment includes:

- **LON-DC1**: Windows Server 2025 domain controller for the **contoso.com** domain.
- **LON-SVR1**: Windows Server 2025 member server joined to the **contoso.com** domain.
- **LON-SVR2**: Windows Server 2025 member server joined to the **contoso.com** domain.

The servers are on the same lab network and can communicate with each other. When a lab benefits from demonstrating server-to-server behavior, it is appropriate to switch between these VMs in the lab platform and send traffic between them. Examples include testing firewall rules, validating name resolution, accessing a web site hosted on another server, testing file share access, checking domain-based administration, or confirming remote management behavior.

## Lab development style

When developing or expanding labs, prefer the style used in Lab 5:

- Build a point-and-click learner path first. Use graphical tools such as Server Manager, Windows Admin Center, IIS Manager, Services, Event Viewer, Computer Management, Local Security Policy, Windows Defender Firewall with Advanced Security, File Explorer, Settings, and Microsoft Edge where they fit the topic.
- Keep PowerShell as a validation, comparison, or optional automation layer unless the lab topic is specifically PowerShell-focused.
- Name Windows Server 2025 UI locations carefully. Include menu paths, pane names, tab names, button names, wizard page names, and expected labels so learners can follow the steps without guessing.
- Explain where the learner is in the interface before asking them to select or change something.
- Include short validation moments after each major change. Use GUI validation first where possible, then add focused PowerShell commands when they make the result clearer or repeatable.
- Include controlled troubleshooting steps when useful, such as disabling and re-enabling a rule, stopping and starting a service, or testing access from a second server.
- Prefer built-in rules, features, and management tools before creating custom configuration. When a custom setting is needed, explain why.
- Review security impact in plain language. For example, prefer scoping firewall rules over disabling the firewall, and call out when a broad lab setting would need tighter production controls.
- Add a brief administrative change summary near the end of labs when learners install roles, change security settings, configure services, or alter network access.
- Avoid making every lab a command transcript. The learner should understand the administrative workflow, the tool locations, the result, and the operational reason for the change.
