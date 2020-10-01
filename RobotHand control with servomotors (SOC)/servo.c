
#include <linux/module.h>
#include <linux/version.h>
#include <linux/kernel.h>
#include <linux/types.h>
#include <linux/kdev_t.h>
#include <linux/fs.h>
#include <linux/device.h>
#include <linux/cdev.h>

#include <asm/uaccess.h>
#include <xen/page.h>

#include <linux/slab.h>
#include <linux/platform_device.h>
#include <linux/of.h>
#include <linux/of_address.h>
#include <linux/of_device.h>
#include <linux/of_platform.h>
#include <asm/io.h>

#include <linux/delay.h>

#define MODULE_NAME	"servo"


/* Match table for of_platform binding */
static struct of_device_id servo_match[] = {
	{ .compatible = "fau,myip_servo2", },
	{}
};

MODULE_ALIAS("servo");

static void __iomem *regs;
static struct resource res;

// show finger 0_5

static ssize_t show_finger0(struct device *dev, struct device_attribute *attr,
		char *buf)
{
	return scnprintf(buf, PAGE_SIZE, "%d\n", ioread32(regs+sizeof(u32)*0) );
}


static ssize_t show_finger1(struct device *dev, struct device_attribute *attr,
		char *buf)
{
	return scnprintf(buf, PAGE_SIZE, "%d\n", ioread32(regs+sizeof(u32)*1) );
}



static ssize_t show_finger2(struct device *dev, struct device_attribute *attr,
		char *buf)
{
	return scnprintf(buf, PAGE_SIZE, "%d\n", ioread32(regs+sizeof(u32)*2) );
}

static ssize_t show_finger3(struct device *dev, struct device_attribute *attr,
		char *buf)
{
	return scnprintf(buf, PAGE_SIZE, "%d\n", ioread32(regs+sizeof(u32)*3) );
}


static ssize_t show_finger4(struct device *dev, struct device_attribute *attr,
		char *buf)
{
	return scnprintf(buf, PAGE_SIZE, "%d\n", ioread32(regs+sizeof(u32)*4) );
}

static ssize_t show_finger5(struct device *dev, struct device_attribute *attr,
		char *buf)
{
	return scnprintf(buf, PAGE_SIZE, "%d\n", ioread32(regs+sizeof(u32)*5) );
}



//my store finger Reg 0_5

static ssize_t store_finger0(struct device *dev, struct device_attribute *attr,
		const char *buf, size_t count)
{
    u32 val;
	sscanf(buf, "%d",&val);

	iowrite32(val, regs+sizeof(u32)*0);
	return count;
}


static ssize_t store_finger1(struct device *dev, struct device_attribute *attr,
		const char *buf, size_t count)
{
    u32 val;
	sscanf(buf, "%d",&val);

	iowrite32(val, regs+sizeof(u32)*1);
	return count;
}

static ssize_t store_finger2(struct device *dev, struct device_attribute *attr,
		const char *buf, size_t count)
{
    u32 val;
	sscanf(buf, "%d",&val);

	iowrite32(val, regs+sizeof(u32)*2);
	return count;
}

static ssize_t store_finger3(struct device *dev, struct device_attribute *attr,
		const char *buf, size_t count)
{
    u32 val;
	sscanf(buf, "%d",&val);

	iowrite32(val, regs+sizeof(u32)*3);
	return count;
}

static ssize_t store_finger4(struct device *dev, struct device_attribute *attr,
		const char *buf, size_t count)
{
    u32 val;
	sscanf(buf, "%d",&val);

	iowrite32(val, regs+sizeof(u32)*4);
	return count;
}


static ssize_t store_finger5(struct device *dev, struct device_attribute *attr,
		const char *buf, size_t count)
{
    u32 val;
	sscanf(buf, "%d",&val);

	iowrite32(val, regs+sizeof(u32)*5);
	return count;
}



//...........

static DEVICE_ATTR(finger0,S_IRUGO | S_IWUGO, show_finger0, store_finger0);
static DEVICE_ATTR(finger1,S_IRUGO | S_IWUGO, show_finger1, store_finger1);
static DEVICE_ATTR(finger2,S_IRUGO | S_IWUGO, show_finger2, store_finger2);
static DEVICE_ATTR(finger3,S_IRUGO | S_IWUGO, show_finger3, store_finger3);
static DEVICE_ATTR(finger4,S_IRUGO | S_IWUGO, show_finger2, store_finger4);
static DEVICE_ATTR(finger5,S_IRUGO | S_IWUGO, show_finger2, store_finger5);

static int register_files(struct device *dev)
{
	device_create_file(dev, &dev_attr_finger0);
        device_create_file(dev, &dev_attr_finger1);
        device_create_file(dev, &dev_attr_finger2);
        device_create_file(dev, &dev_attr_finger3);
        device_create_file(dev, &dev_attr_finger4);
        device_create_file(dev, &dev_attr_finger5);
	return 0;
}

static int unregister_files(struct device *dev)
{
	device_remove_file(dev, &dev_attr_finger0);
        device_remove_file(dev, &dev_attr_finger1);
        device_remove_file(dev, &dev_attr_finger2);
        device_remove_file(dev, &dev_attr_finger3);
        device_remove_file(dev, &dev_attr_finger4);
        device_remove_file(dev, &dev_attr_finger5);
	return 0;
} 



static int servo_probe(struct platform_device *op)
{

	int ret;
    
	ret = of_address_to_resource(op->dev.of_node, 0, &res);
	if (ret) {
		printk(KERN_WARNING "<%s>: Failed to obtain device tree resource\n",MODULE_NAME);
		return ret;
	}

	printk(KERN_WARNING "<%s>: Physical address to resource is %x\n",MODULE_NAME, (unsigned int) res.start);

	if (!request_mem_region(res.start, 32, MODULE_NAME)) {
		printk(KERN_WARNING "<%s>: Failed to request I/O memory\n",MODULE_NAME);
		return -EBUSY;
	}

	regs = ioremap(res.start,32); /* Verify it's non-null! */

	if(regs == NULL)
	{
		release_mem_region(res.start, 32);
		return -EBUSY;
	}
	printk(KERN_WARNING "<%s>: Access address to registers is %x\n",MODULE_NAME, (unsigned int) regs);

	register_files(&(op->dev));

	return 0; /* Success */
}

static int servo_remove(struct platform_device *op)
{
	unregister_files(&(op->dev));
	iounmap(regs);
	release_mem_region(res.start, 32);

	printk(KERN_WARNING "<%s>: removed\n",MODULE_NAME);
	return 0; /* Success */
}

static struct platform_driver servo_driver = {
	.probe = servo_probe,
	.remove = servo_remove,
	.driver = {
		.name = MODULE_NAME,
		.owner = THIS_MODULE,
		.of_match_table = servo_match,
	},
};

module_platform_driver(servo_driver);


MODULE_DESCRIPTION("Driver for pwm on zc706");
MODULE_LICENSE("GPL");



