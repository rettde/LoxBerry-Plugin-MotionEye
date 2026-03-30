# LoxBerry-Plugin-MotionEye

A comprehensive LoxBerry plugin for MotionEye - the web-based interface for Motion video surveillance.

## Features

- **Python 3 Compatible**: Full support for Python 3.7+
- **Latest MotionEye Integration**: Uses stable MotionEye version 0.43.1
- **Raspberry Pi Optimized**: Enhanced ARM architecture support
- **Robust Error Handling**: Comprehensive installation validation
- **Modern Debian Support**: Compatible with Debian 12+ and externally managed Python environments

## System Requirements

- **LoxBerry**: 3.0.0.1 or higher
- **Python**: 3.7 or higher
- **Architecture**: ARM (armhf/arm64) or x86_64
- **Storage**: Minimum 1GB free space for media files

## Installation

### Automatic Installation (Recommended)

1. Install via LoxBerry Plugin Management
2. The plugin will automatically:
   - Install Motion daemon (version 4.7.1)
   - Install MotionEye (version 0.43.1)
   - Configure systemd services
   - Set proper permissions

### Manual Installation

```bash
# Clone the repository
git clone https://github.com/mschlenstedt/LoxBerry-Plugin-MotionEye.git

# Install the plugin
cd LoxBerry-Plugin-MotionEye
# Follow LoxBerry plugin installation procedures
```

## Configuration

### Web Interface

Access MotionEye web interface at:
```
http://[your-loxberry-ip]:8765/
```

**Default Credentials:**
- Username: `admin`
- Password: (empty - set immediately for security)

### Configuration Files

- **MotionEye Config**: `/etc/motioneye/motioneye.conf`
- **Plugin Config**: `/config/plugins/motioneye/`
- **Media Storage**: `/data/plugins/motioneye/`
- **Log Files**: `/log/plugins/motioneye/`

## Key Improvements

### Version 1.0.3.1

- ✅ **Fixed version consistency** between plugin.cfg and release.cfg
- ✅ **Stable MotionEye version** (0.43.1) instead of bleeding-edge
- ✅ **Python 3 validation** with minimum version checking
- ✅ **Enhanced error handling** for both Motion and MotionEye installation
- ✅ **Modern Debian compatibility** with break-system-packages flag
- ✅ **Robust dependency management** with automatic fixes

### Installation Enhancements

1. **Pre-flight Checks**: Validates Python 3.7+ availability
2. **Architecture Detection**: Automatic ARM/x86_64 detection
3. **Download Validation**: Verifies package downloads
4. **Dependency Resolution**: Automatic fixing of broken dependencies
5. **Service Management**: Proper systemd service configuration

## Troubleshooting

### Common Issues

**Python Version Error:**
```bash
# Check Python version
python3 --version
# Should be 3.7 or higher
```

**MotionEye Installation Failed:**
```bash
# Check pip installation
python3 -m pip --version
# Manually install if needed
python3 -m pip install motioneye==0.43.1
```

**Service Not Starting:**
```bash
# Check service status
systemctl status motioneye
# View logs
journalctl -u motioneye -f
```

### Log Locations

- **Installation Logs**: `/log/plugins/motioneye/`
- **System Logs**: `journalctl -u motioneye`
- **Motion Logs**: Integrated into MotionEye web interface

## Security Recommendations

1. **Change Default Password**: Immediately set a strong admin password
2. **Network Access**: Consider firewall rules for port 8765
3. **Regular Updates**: Keep MotionEye and dependencies updated
4. **File Permissions**: Ensure media directories are properly secured

## Support

- **GitHub Issues**: [Report bugs and feature requests](https://github.com/mschlenstedt/LoxBerry-Plugin-MotionEye/issues)
- **LoxBerry Forum**: [Community support](https://www.loxberry.com/forum)
- **MotionEye Documentation**: [Official docs](https://github.com/motioneye-project/motioneye/wiki)

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## Version History

- **1.0.3.1**: Critical fixes for Python 3 compatibility and stable MotionEye integration
- **1.0.2.2**: Previous stable release
- **1.0.3.0**: Development version

---

**Note**: This plugin is designed specifically for LoxBerry systems and may not work on other platforms without modification.
